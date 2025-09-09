import prisma from "../config/prisma.js";

/**
 * Listado de países (igual que en clients)
 */
export async function listCountries() {
  return prisma.paisos.findMany({
    orderBy: { pais: "asc" },
    select: { idPais: true, pais: true },
  });
}

/**
 * Listado de provincias (para poblar el select al editar/crear)
 */
export async function listProvinces() {
  return prisma.provincies.findMany({
    orderBy: { provincia: "asc" },
    select: { idPais: true, idProvincia: true, provincia: true },
  });
}

/**
 * Listar todos los hoteles con nombre, estrellas, ciudad, país y provincia
 */
export async function listHotels() {
  return prisma.hotels.findMany({
    orderBy: { nomHotel: "asc" },
    include: {      
      paisos: true      
    },
  });
}

/**
 * Crea un nuevo hotel dentro de una transacción.
 */
export async function createHotel(data) {
  return prisma.$transaction(async (tx) => {
    return tx.hotels.create({
      data: {
        nomHotel: data.nomHotel,
        estrelles: data.estrelles ? parseInt(data.estrelles, 10) : null,
        idPais: data.idPais ? parseInt(data.idPais, 10) : null,        
        ciutat: data.ciutat,
      },
      include: {      
        paisos: true      
      },
    });
  });
}

/**
 * Actualiza un hotel dentro de una transacción.
 */
export async function updateHotel(idHotel, data) {
  // reconstruimos sólo los campos que vienen definidos
  const toUpdate = {};
  if (data.nomHotel !== undefined) toUpdate.nomHotel = data.nomHotel;
  if (data.estrelles !== undefined && data.estrelles !== "") {
    toUpdate.estrelles = parseInt(data.estrelles, 10);
  }
  if (data.idPais !== undefined) {
    toUpdate.idPais = data.idPais ? parseInt(data.idPais, 10) : null;
  }  
  if (data.ciutat !== undefined) toUpdate.ciutat = data.ciutat;

  return prisma.$transaction(async (tx) => {
    return tx.hotels.update({
      where: { idHotel: Number(idHotel) },
      data: toUpdate,
      include: {      
        paisos: true      
      },
    });
  });
}

/**
 * Elimina un hotel dentro de una transacción.
 */
export async function deleteHotel(idHotel) {
  return prisma.$transaction(async (tx) => {
    return tx.hotels.delete({
      where: { idHotel: Number(idHotel) },
    });
  });
}
