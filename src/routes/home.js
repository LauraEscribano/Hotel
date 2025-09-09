// src/routes/home.js
import express from 'express';
import prisma from '../config/prisma.js';

const router = express.Router();

router.get('/home', async (req, res, next) => {
  try {
    // Consulta los hoteles, incluyendo la información de la provincia y país.
    const hotels = await prisma.hotels.findMany({      
        include: {      
          paisos: true      
        },      
    });

    // Agrupar hoteles por "país - ciudad"
    const groupedHotels = {};
    hotels.forEach(hotel => {
      // Obtenemos el nombre del país desde la relación, si está disponible.
      const country = hotel.paisos?.pais || 'Sin país';
      const city = hotel.ciutat || 'Sin ciudad';
      const groupKey = `${country} - ${city}`;
      if (!groupedHotels[groupKey]) {
        groupedHotels[groupKey] = [];
      }
      groupedHotels[groupKey].push({
        idHotel: hotel.idHotel,
        nomHotel: hotel.nomHotel,
      });
    });

    // Pasamos groupedHotels a la vista
    res.render('general/home', { groupedHotels });
  } catch (error) {
    next(error);
  }
});

export default router;
