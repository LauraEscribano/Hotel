import prisma from '../config/prisma.js';
import { subMonths, startOfMonth, endOfMonth } from 'date-fns';

export async function getTotals() {
  const [ totalClients, totalHotels, totalReservations ] = await Promise.all([
    prisma.clients.count(),
    prisma.hotels.count(),
    prisma.reserves.count()
  ]);
  return { totalClients, totalHotels, totalReservations };
}

/**
 * Devuelve arrays { labels: [...], data: [...] } para los últimos 6 meses
 */
export async function getMonthlyNewClients() {
  const now = new Date();
  const months = Array.from({ length: 6 }).map((_, i) => {
    const date = subMonths(now, 5 - i);
    return { 
      label: date.toLocaleString('default',{ month:'short','year':'numeric' }),
      start: startOfMonth(date),
      end:   endOfMonth(date)
    };
  });

  const counts = await Promise.all(months.map(({ start, end }) =>
    prisma.clients.count({ where: { data_naixement: { gte: start, lt: end } } })
  ));

  return {
    labels: months.map(m=>m.label),
    data:   counts
  };
}

export async function getMonthlyReservations() {
  const now = new Date();
  const months = Array.from({ length: 6 }).map((_, i) => {
    const date = subMonths(now, 5 - i);
    return { 
      label: date.toLocaleString('default',{ month:'short','year':'numeric' }),
      start: startOfMonth(date),
      end:   endOfMonth(date)
    };
  });

  const counts = await Promise.all(months.map(({ start, end }) =>
    prisma.reserves.count({ where: { dataInici: { gte: start, lt: end } } })
  ));

  return {
    labels: months.map(m=>m.label),
    data:   counts
  };
}

/**
 * Distribución de reservas por hotel
 */
export async function getReservationsByHotel() {
  const raw = await prisma.$queryRaw`
    SELECT h.nomHotel AS name, COUNT(r.numReserva) AS cnt
    FROM hotels h
    LEFT JOIN reserves r ON r.idHotel = h.idHotel
    GROUP BY h.idHotel, h.nomHotel
    ORDER BY cnt DESC
    LIMIT 10
  `;
  return {
    labels: raw.map(r=>r.name),
    data:   raw.map(r=>Number(r.cnt))
  };
}
