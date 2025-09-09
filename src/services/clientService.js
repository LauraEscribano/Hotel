// src/services/clientService.js
import prisma from "../config/prisma.js";

/**
 * Obtiene los datos del cliente asociado a un usuario.
 * Se asume que el objeto usuario (usuaris) tiene el campo opcional idClient.
 * @param {number} userId - El id del usuario autenticado (idUsuari).
 * @returns {Promise<Object>} - Los datos del cliente de la tabla clients.
 * @throws {Error} - Si el usuario no tiene cliente asociado o no se encuentra.
 */
export const getClientDataByUser = async (userId) => {
  // Primero recuperamos el idClient del usuario a partir del idUsuari
  const user = await prisma.usuaris.findUnique({
    where: { idUsuari: userId },
    select: { idClient: true },
  });

  if (!user || !user.idClient) {
    throw new Error("No se encontró información de cliente para el usuario.");
  }

  // Con el idClient, buscamos la información en la tabla clients
  const clientData = await prisma.clients.findUnique({
    where: { idClient: user.idClient },
  });

  if (!clientData) {
    throw new Error("No se encontró el registro del cliente.");
  }

  return clientData;
};

export async function listCountries() {
  return prisma.paisos.findMany({
    orderBy: { pais: "asc" },
    select: { idPais: true, pais: true },
  });
}

export async function list() {
  return prisma.clients.findMany({
    orderBy: { cognoms: "asc" },
    select: {
      idClient: true,
      nom: true,
      cognoms: true,
      data_naixement: true,
      dni: true,
      email: true,
      telefon: true,
      carrer: true,
      numero: true,
      pis: true,
      ciutat: true,
      idPais: true,
      idProvincia: true,
      codi_postal: true,
      data_actualitzacio: true,
      actiu: true,

      paisos: {
        select: { pais: true }, // alias: <obj>.paisos.nom
      },
    },
  });
}

export async function create(data) {
  return prisma.clients.create({
    data: {
      nom: data.nom,
      cognoms: data.cognoms,
      data_naixement: data.data_naixement
        ? new Date(data.data_naixement)
        : null,
      dni: data.dni || null,
      email: data.email || null,
      telefon: data.telefon || null,
      carrer: data.carrer || null,
      numero: data.numero || null,
      pis: data.pis || null,
      ciutat: data.ciutat || null,
      idPais: data.idPais ? parseInt(data.idPais, 10) : null,
      codi_postal: data.codi_postal || null,
    },
    include: {
      paisos: {
        select: { pais: true }, // ahora cli.paisos.pais viene en la respuesta
      },
    },
  });
}

/* -------- UPDATE (Modificar cliente) --------
   Recibe idClient y un objeto data con los campos a cambiar. */
export async function update(idClient, data) {
  // Filtra solo campos permitidos
  const allowed = [
    "nom",
    "cognoms",
    "data_naixement",
    "dni",
    "email",
    "telefon",
    "carrer",
    "numero",
    "pis",
    "ciutat",
    "idPais",
    "codi_postal",
    "actiu",
  ];

  // Filtra solo los campos que están en allowed y no son undefined  
  const toUpdate = {};
  /* Itera sobre los campos permitidos y asigna solo los que están en data y no son undefined */
  for (const field of allowed) {
    const val = data[field];
    // 1) Si no viene definido, salto
    if (val === undefined) continue;
    // 2) Si es cadena y está en blanco, salto (preservo NULL original)
    if (typeof val === 'string' && val.trim() === '') continue;
    // 3) Casos especiales
    if (field === 'idPais') {
      toUpdate[field] = val ? parseInt(val, 10) : null;
    } else if (field === 'data_naixement') {
      toUpdate[field] = val ? new Date(val) : null;
    } else {
      toUpdate[field] = val;
    }
  }

  toUpdate.data_actualitzacio = new Date(); // marca actualización

  return prisma.clients.update({
    where: { idClient: Number(idClient) },
    data: toUpdate,
    include: {
      paisos: {
        select: { pais: true }, 
      },
    },
  });
}

/* -------- softDelete (Marcar inactivo) --------
     Solo pone actiu = 0                                       */
export async function softDelete(idClient) {
  return prisma.clients.update({
    where: { idClient: Number(idClient) },
    data: { actiu: 0, data_actualitzacio: new Date() },
  });
}
