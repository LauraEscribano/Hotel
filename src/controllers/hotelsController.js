import prisma from '../config/prisma.js';
import {
  listHotels,
  listCountries,
  listProvinces,
  createHotel,
  updateHotel,
  deleteHotel
} from '../services/hotelService.js';

/* —— LISTAR —— */
export const index = async (req, res, next) => {
  try {
    const [hotels, countries, provinces] = await Promise.all([
      listHotels(),
      listCountries(),
      listProvinces()
    ]);
    res.render('admin/hotels', { hotels, countries, provinces });
  } catch (err) {
    next(err);
  }
};

/* —— CREAR —— */
export const store = async (req, res) => {
  try {
    const h = await createHotel(req.body);
    return res.status(201).json(h);
  } catch (err) {
    console.error('💥 Error creando hotel:', err);
    return res.status(500).json({ error: 'Error interno al crear hotel.' });
  }
};

/* —— ACTUALIZAR —— */
export const updateOne = async (req, res) => {
  try {
    const id = Number(req.params.idHotel);
    const h  = await updateHotel(id, req.body);
    return res.json(h);
  } catch (err) {
    console.error('💥 Error actualizando hotel:', err);
    return res.status(500).json({ error: 'Error interno al actualizar hotel.' });
  }
};

/* —— BORRAR —— */
export const destroy = async (req, res) => {
  try {
    await deleteHotel(req.params.idHotel);
    return res.json({ ok: true, idHotel: req.params.idHotel });
  } catch (err) {
    console.error('💥 Error borrando hotel:', err);
    return res.status(500).json({ error: 'Error interno al borrar hotel.' });
  }
};

export default { index, store, updateOne, destroy };
