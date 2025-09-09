// src/utils/priceCalculator.js
import prisma from '../config/prisma.js';

const calculateNights = (checkIn, checkOut) => {
  const startDate = new Date(checkIn);
  const endDate = new Date(checkOut);
  const diffTime = Math.floor((endDate - startDate) / (1000 * 60 * 60 * 24));  
  return diffTime;
};

/*
 * Calcula el precio total y el precio promedio por noche para una habitación, considerando su hotel, categoría y rango de fechas.
 * Se recorre el rango de fechas día a día, se determina la temporada para cada noche y se suma la tarifa correspondiente. 
 */

export const calculateReservationPrice = async (hotelId, idCategoria, roomsRequested, checkIn, checkOut) => {
  const startDate = new Date(checkIn);
  const endDate = new Date(checkOut);
  const nights = calculateNights(checkIn, checkOut);
  let totalPrice = 0;
  
  // Iterar noche a noche
  for (let day = new Date(startDate); day < endDate; day.setDate(day.getDate() + 1)) {
    const currentDay = new Date(day);
    
    // Determinar la temporada a la que pertenece la noche actual
    const temporada = await prisma.temporades.findFirst({
      where: {
        dataInici: { lte: currentDay },
        dataFi: { gte: currentDay }
      }
    });
    
    if (!temporada) {
      throw new Error(`No se encontró temporada para la fecha ${currentDay.toISOString().split('T')[0]}`);
    }
    
    // Obtener la tarifa para ese hotel, categoría y temporada
    const tariff = await prisma.tarifes.findFirst({
      where: {
        idHotel: hotelId,
        idCategoria: idCategoria,
        idTemporada: temporada.idTemporada
      }
    });
    
    if (!tariff) {
      throw new Error(`No se encontró tarifa para el hotel ${hotelId}, categoría ${idCategoria} y temporada ${temporada.idTemporada}`);
    }
    
    totalPrice += parseFloat(tariff.preu * roomsRequested); // Multiplicamos por el número de habitaciones solicitadas
  }
  
  const pricePerNight = (totalPrice / nights) / roomsRequested; // Precio por noche  
  
  return { totalPrice, pricePerNight, nights };
};
