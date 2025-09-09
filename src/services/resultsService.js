// src/services/resultsService.js
import prisma from "../config/prisma.js";
import { calculateReservationPrice } from "../utils/priceCalculator.js";

// Búsqueda para un hotel específico
export const getResultsByHotel = async (
  hotelId,
  checkIn,
  checkOut,
  requiredCapacity,
  roomsRequested
) => {
  const startDate = new Date(checkIn);
  const endDate = new Date(checkOut);

  //  Obtener habitaciones disponibles del hotel en el rango y que cumplan capacidad
  const rooms = await prisma.habitacions.findMany({
    where: {
      idHotel: hotelId,
      capacitat: { gte: requiredCapacity },
      reserveshab: {
        none: {
          reserves: {
            AND: [
              { dataInici: { lte: endDate } },
              { dataFi: { gte: startDate } },
            ],
          },
        },
      },
    },
    include: {
      categories: true,
    },
  });

  // Agrupar por idCategoria y contar las disponibles
  const groupedByCategory = {};
  rooms.forEach((room) => {
    if (!groupedByCategory[room.idCategoria]) {
      groupedByCategory[room.idCategoria] = { count: 0, representative: room };
    }
    groupedByCategory[room.idCategoria].count++;
  });

  // Solo conservar grupos con al menos roomsRequested habitaciones disponibles
  const filteredGroups = Object.values(groupedByCategory).filter(
    (group) => group.count >= roomsRequested
  );

  // Para cada grupo, obtener las imágenes y calcular precio
  const results = await Promise.all(
    filteredGroups.map(async (group) => {
      const room = group.representative;
      const images = await prisma.imatgesCategoria.findMany({
        where: {
          idHotel: hotelId,
          idCategoria: room.idCategoria,
        },
        orderBy: { ordreImatge: "asc" },
      });

      // Calcula el precio total y el precio por noche para la tarifa correspondiente
      const { totalPrice, pricePerNight, nights } =
        await calculateReservationPrice(
          hotelId,
          room.idCategoria,
          roomsRequested,
          checkIn,
          checkOut
        );

      return {
        ...room,
        nomCategoria: room.categories.nomCategoria,
        images,
        availableCount: group.count,
        preuPerNit: pricePerNight,
        totalPrice,
        nights,
        roomsRequested,
      };
    })
  );
  return results;
};

// Búsqueda a nivel de ciudad (agrupa por hotel y dentro cada hotel por categoría)
export const getResultsByCity = async (
  city,
  checkIn,
  checkOut,
  requiredCapacity,
  roomsRequested
) => {
  const startDate = new Date(checkIn);
  const endDate = new Date(checkOut);

  // Buscar hoteles en la ciudad (con su nombre)
  const hotels = await prisma.hotels.findMany({
    where: { ciutat: city },
    select: { idHotel: true, nomHotel: true },
  });
  const hotelIds = hotels.map((hotel) => hotel.idHotel);
  if (hotelIds.length === 0) return [];

  // Buscar todas las habitaciones de esos hoteles
  const rooms = await prisma.habitacions.findMany({
    where: {
      idHotel: { in: hotelIds },
      capacitat: { gte: requiredCapacity },
      reserveshab: {
        none: {
          reserves: {
            AND: [
              { dataInici: { lte: endDate } },
              { dataFi: { gte: startDate } },
            ],
          },
        },
      },
    },
    include: {
      categories: true,
    },
  });

  // Agrupar por clave compuesta: `${idHotel}-${idCategoria}`
  const compositeGroups = {};
  rooms.forEach((room) => {
    const key = `${room.idHotel}-${room.idCategoria}`;
    if (!compositeGroups[key]) {
      compositeGroups[key] = { count: 0, representative: room };
    }
    compositeGroups[key].count++;
  });

  // Filtrar grupos que tengan al menos roomsRequested disponibles
  const filteredComposite = Object.values(compositeGroups).filter(
    (group) => group.count >= roomsRequested
  );

  // Reorganizar los resultados agrupados por hotel
  const resultsByHotel = {};
  filteredComposite.forEach((group) => {
    const room = group.representative;
    if (!resultsByHotel[room.idHotel]) {
      const hotelInfo = hotels.find((h) => h.idHotel === room.idHotel);
      resultsByHotel[room.idHotel] = {
        idHotel: room.idHotel,
        nomHotel: hotelInfo.nomHotel,
        rooms: [],
      };
    }
    resultsByHotel[room.idHotel].rooms.push({
      ...room,
      availableCount: group.count,
    });
  });

  // Para cada habitación representativa en cada hotel, obtener imágenes y calcular precio
  for (const hotelId in resultsByHotel) {
    const hotelGroup = resultsByHotel[hotelId];
    hotelGroup.rooms = await Promise.all(
      hotelGroup.rooms.map(async (room) => {
        const images = await prisma.imatgesCategoria.findMany({
          where: {
            idHotel: room.idHotel,
            idCategoria: room.idCategoria,
          },
          orderBy: { ordreImatge: "asc" },
        });
        const { totalPrice, pricePerNight, nights } =
          await calculateReservationPrice(
            room.idHotel,
            room.idCategoria,
            roomsRequested,
            checkIn,
            checkOut
          );
        return {
          ...room,
          nomCategoria: room.categories.nomCategoria,
          images,
          preuPerNit: pricePerNight,
          totalPrice,
          nights,
          roomsRequested,
        };
      })
    );
  }

  return Object.values(resultsByHotel);
};

// Función principal que decide la búsqueda según el destino
export const getResultsData = async (options) => {
  if (options.type === "hotel") {
    const hotelId = options.hotelId;
    const rooms = await getResultsByHotel(
      hotelId,
      options.checkIn,
      options.checkOut,
      options.requiredCapacity,
      options.roomsRequested
    );
    return { type: "hotel", hotelId, rooms };
  } else if (options.type === "city") {
    const city = options.city;
    const hotelsData = await getResultsByCity(
      city,
      options.checkIn,
      options.checkOut,
      options.requiredCapacity,
      options.roomsRequested
    );
    return { type: "city", city, hotels: hotelsData };
  } else {
    throw new Error("Tipo de búsqueda inválido");
  }
};
