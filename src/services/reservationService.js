// src/services/reservationService.js
import prisma from "../config/prisma.js";

/**
 * Obtiene los servicios disponibles para un hotel (donde estén disponibles)
 * y combina datos de la tabla serveis (para el nombre) y serveishotels (para el precio).
 * @param {number} hotelId - El id del hotel.
 * @returns {Promise<Array>} Array de objetos con { idServei, nomServei, preu }.
 */
export const getHotelServices = async (hotelId, rooms, nights) => {
  // Consultamos serveishotels filtrado por hotel y que estén disponibles (disponible = true)
  const services = await prisma.serveishotels.findMany({
    where: {
      idHotel: hotelId,
      disponible: true,
    },
    include: {
      serveis: true, // Esto nos trae el objeto de la tabla serveis que contiene nomServei
    },
  });

  // Mapear para simplificar el objeto
  return services.map((service) => ({
    idServei: service.idServei,
    nomServei: service.serveis.nomServei,
    preu: service.preu * rooms * nights, // Multiplicamos por el número de habitaciones y noches
  }));
};

export async function getAvailableRooms({
  hotelId,
  idCategoria,
  checkIn,
  checkOut,
  requiredCapacity,
  roomsRequested,
}) {
  const startDate = new Date(checkIn);
  const endDate = new Date(checkOut);

  const rooms = await prisma.habitacions.findMany({
    where: {
      idHotel: hotelId,
      idCategoria,
      capacitat: { gte: requiredCapacity },
      reserveshab: {
        none: {
          reserves: {
            AND: [
              { dataInici: { lte: endDate } }, // reserva empieza antes de fin
              { dataFi: { gte: startDate } }, // …y acaba después de inicio
            ],
          },
        },
      },
    },
    orderBy: { numeroHabitacio: "asc" },
    select: { numeroHabitacio: true },
  });

  // Tomamos sólo los necesarios y convertimos a array de números
  return rooms.slice(0, roomsRequested).map((r) => r.numeroHabitacio);
}

/**
 * Realiza la reserva completa (reserves + reserveshab + reservesserveis) en una transacción.
 * Devuelve { newReserve, roomNumbers, code }.
 */
export async function makeReservation({
  hotelId,
  idCategoria,
  checkIn,
  checkOut,
  guests,
  roomsRequested,
  requiredCapacity,
  selectedServices = [],
  clientId,
}) {
  // 1) Seleccionar habitaciones
  const roomNumbers = await getAvailableRooms({
    hotelId,
    idCategoria,
    checkIn,
    checkOut,
    requiredCapacity,
    roomsRequested,
  });

  return await prisma.$transaction(async (tx) => {
    // 2) Calcular numReserva (autoincremental por hotel)
    const last = await tx.reserves.findMany({
      orderBy: { numReserva: "desc" }, 
      select: { numReserva: true },
    });
    const numReserva = (last[0]?.numReserva || 0) + 1;

    // Formatear código: RES-<AÑO>-<8 dígitos>
    const year = new Date(checkIn).getFullYear();
    const code = `RES-${year}-${String(numReserva).padStart(8, "0")}`;

    // 3) Crear reserva principal
    const newReserve = await tx.reserves.create({
      data: {
        idHotel: hotelId,
        numReserva,
        codiReserva: code,
        idClient: clientId ?? null,
        dataInici: new Date(checkIn),
        dataFi: new Date(checkOut),
      },
    });

    // 4) Crear detalle de habitación por cada número
    for (const numHabitacio of roomNumbers) {
      await tx.reserveshab.create({
        data: { idHotel: hotelId, numReserva, numHabitacio, persones: guests },
      });
    }

    // 5) Insertar servicios
    for (const idServei of selectedServices) {
      await tx.reservesserveis.create({
        data: {
          idHotel: hotelId,
          numReserva,
          idServei,
          quantitat: roomsRequested,
        },
      });
    }

    return { code };
  });
}
