// src/routes/reservation.js
import express from "express";
import { showReservationDetails, confirmReservationDetails, showConfirmation } from "../controllers/reservationController.js";

const router = express.Router();

// 1. Pantalla penúltima: repasar datos antes de confirmar
router.get("/details", showReservationDetails);

// 2. Procesar la reserva y REDIRECT a confirmation
router.post("/confirm", confirmReservationDetails);

// 3. Pantalla final: muestra confirmation.ejs
router.get("/confirmation", showConfirmation);

export default router;
