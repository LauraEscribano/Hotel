import { da } from 'date-fns/locale';
import prisma from '../config/prisma.js';
import { addDays, startOfDay } from 'date-fns';



export async function getCountries() {
  return prisma.paisos.findMany({
    orderBy: { pais: 'asc' }
  });
}

export async function getClientProfile(idClient) {
  return prisma.clients.findUnique({
    where: { idClient },
    include: {
      paisos: { select: { pais: true } }
    }
  });
}

export async function updateClientProfile(idClient, data) {
  // solo campos editables
  const toUpdate = {
    nom: data.nombre,
    cognoms: data.apellidos,
    data_naixement: new Date(data.fechaNacimiento),
    telefon: data.telefono,
    carrer: data.calle || null,
    numero: data.numero || null,
    pis: data.piso || null,
    ciutat: data.ciudad || null,
    codi_postal: data.codigoPostal || null,
    idPais: data.pais ? parseInt(data.pais,10) : null,
    data_actualitzacio: new Date()
  };
  
  return prisma.$transaction(async (tx) => {
    return tx.clients.update({
      where: { idClient },
      data: toUpdate,
      include: {
        paisos: { select: { pais: true } }
      }
    });  
  }); 
}



export async function getActiveReservations(idClient) {
  const today = startOfDay(new Date());
  return prisma.reserves.findMany({
    where: {
      idClient,
      dataFi: { gte: today }
    },
    include: {
      hotels: true,
      reserveshab: {
        include: { habitacions: { include: { categories: true } } }
      }
    },
    orderBy: { dataInici: 'asc' }
  });
}

export async function getReservationHistory(idClient) {
  const today = startOfDay(new Date());
  return prisma.reserves.findMany({
    where: {
      idClient,
      dataFi: { lt: today }
    },
    include: {
      hotels: true,
      reserveshab: {
        include: { habitacions: { include: { categories: true } } }
      }
    },
    orderBy: { dataInici: 'desc' }
  });
}
