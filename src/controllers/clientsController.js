// src/controllers/clientsController.js
import { list, listCountries, create, update, softDelete } from '../services/clientService.js';
import prisma from '../config/prisma.js';

/* ---------- LISTAR ---------- */
export const index = async (req, res, next) => {
  try {
    const [clients, countries] = await Promise.all([list(), listCountries()]);
    res.render('admin/clients', { clients, countries });   // ⬅️ pasa países
  } catch (err) { next(err); }
};

/* ---------- CREAR (POST /admin/clients) ---------- */
export const store = async (req, res, next) => {
  try {
    const data = req.body;

    // Comprobar DNI duplicado
    if (data.dni) {
      const exists = await prisma.clients.findUnique({
        where: { dni: data.dni }
      });
      if (exists) {
        return res.status(400).json({ error: 'Ya existe un cliente con ese DNI.' });
      }
    }
    // Crear cliente
    const nuevo = await create(data);
    // Volver a cargar con relación paisos para devolver nombre de país
    const full = await prisma.clients.findUnique({
      where: { idClient: nuevo.idClient },
      include: { paisos: { select: { pais: true } } }
    });

    return res.status(201).json(full);
  } catch (err) {
    console.error("💥 Error creando nuevo cliente:", err);
    // Capturar error único de Prisma (P2002) sobre DNI
    if (err.code === 'P2002' && err.meta.target.includes('uk_dni')) {
      return res.status(400).json({ error: 'Ya existe un cliente con ese DNI.' });
    }
    return res.status(500).json({ error: 'Error interno al crear cliente.' });
  }
};

/* ---------- ACTUALIZAR (PUT /admin/clients/:id) ---------- */
export const updateOne = async (req, res, next) => {
  try {
    const id = Number(req.params.id);
    const data = req.body;

    // Comprobar DNI duplicado (distinto de este id)
    if (data.dni) {
      const exists = await prisma.clients.findUnique({
        where: { dni: data.dni }
      });
      if (exists && exists.idClient !== id) {
        return res.status(400).json({ error: 'Ya existe un cliente con ese DNI.' });
      }
    }
    // Actualizar
    await update(id, data);
    // Recargar con relación paisos
    const full = await prisma.clients.findUnique({
      where: { idClient: id },
      include: { paisos: { select: { pais: true } } }
    });
    return res.json(full);
  } catch (err) {
    console.error("💥 Error actualizando cliente:", err);
    if (err.code === 'P2002' && err.meta.target.includes('uk_dni')) {
      return res.status(400).json({ error: 'Ya existe un cliente con ese DNI.' });
    }
    return res.status(500).json({ error: 'Error interno al actualizar cliente.' });
  }
};

/* ---------- ELIMINAR LÓGICO (DELETE /admin/clients/:id) ---------- */
export const destroy = async (req, res, next) => {
  try {
    const resultado = await softDelete(req.params.id);
    res.json({ ok: true, idClient: resultado.idClient });
  } catch (err) {
    next(err);
  }
};


export default { index, store, updateOne, destroy };
  