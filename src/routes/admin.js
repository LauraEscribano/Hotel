// src/routes/admin.js
import express from "express";
import { ensureAuthenticated } from "../middlewares/authMiddleware.js";
import { ensureAdmin } from "../middlewares/roleMiddleware.js";
import { showDashboard } from '../controllers/dashboardController.js';
import clientsController from "../controllers/clientsController.js";
import hotelsController from "../controllers/hotelsController.js";

const router = express.Router();

router.get(
  '/dashboard',
  ensureAuthenticated, ensureAdmin,
  showDashboard
);

/*
 * Rutas para gestionar clientes
 */

router.get(
  "/clients",
  ensureAuthenticated,
  ensureAdmin,
  clientsController.index
);

router.post(
  "/clients",
  ensureAuthenticated,
  ensureAdmin,
  express.json(),
  clientsController.store
);

router.put(
  "/clients/:id",
  ensureAuthenticated,
  ensureAdmin,
  express.json(),
  clientsController.updateOne
);

router.delete(
  "/clients/:id",
  ensureAuthenticated,
  ensureAdmin,
  clientsController.destroy
);

/*
 * Rutas para gestionar hoteles
 */

router.get("/hotels", ensureAuthenticated, ensureAdmin, hotelsController.index);
router.post(
  "/hotels",
  ensureAuthenticated,
  ensureAdmin,
  express.json(),
  hotelsController.store
);
router.put(
  "/hotels/:idHotel",
  ensureAuthenticated,
  ensureAdmin,
  express.json(),
  hotelsController.updateOne
);
router.delete(
  "/hotels/:idHotel",
  ensureAuthenticated,
  ensureAdmin,
  hotelsController.destroy
);

export default router;
