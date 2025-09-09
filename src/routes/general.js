// src/routes/general.js
import express from 'express';
const router = express.Router();

// Ruta para la página principal
router.get('/home', (req, res) => {
  res.render('general/home');
});

// Otras rutas generales se pueden agregar aquí
// router.get('/about', (req, res) => {
//   res.render('general/about');
// });

export default router;
