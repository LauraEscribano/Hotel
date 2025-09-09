import express from 'express';
const router = express.Router();

// En una ruta intermedia, por ejemplo:
router.get('/select', async (req, res, next) => {
    // Se obtienen los parámetros necesarios (por ejemplo, desde el query o el body)
    const { hotelId, idCategoria, nomCategoria, checkIn, checkOut, rooms, guests, nights, totalPrice } = req.query;
    // Guardar en la sesión
    req.session.reservationDetails = { hotelId, idCategoria, nomCategoria, checkIn, checkOut, rooms, guests, nights, totalPrice };
    console.log('Query:', req.query);
    console.log('Detalles de la reserva guardados en la sesión:', req.session.reservationDetails);
   
    res.redirect('/reservation/details');
  });

export default router;
  