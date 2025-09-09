// src/routes/api/apiProvincias.js
// Ruta para obtener las provincias de un país
import express from 'express';
import prisma from '../../config/prisma.js';

const router = express.Router();

router.get('/provincias', async (req, res, next) => {
  const { paisId } = req.query;
  if (!paisId) {
    return res.status(400).json({ error: 'El parámetro paisId es requerido' });
  }
  try {
    const provincias = await prisma.provincies.findMany({
      where: { idPais: parseInt(paisId) }
    });
    res.json(provincias);
  } catch (error) {
    next(error);
  }
});

export default router;
