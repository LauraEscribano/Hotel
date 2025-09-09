// src/routes/auth.js
import express from "express";
import { login, logout, register } from "../controllers/authController.js";
import prisma from "../config/prisma.js";

const router = express.Router();

// Ruta para mostrar el formulario de registro
router.get("/register", async (req, res, next) => {
  try {
    // Obtener la lista de países para mostrar en el formulario
    const paisos = await prisma.paisos.findMany();

    res.render("auth/register", {
      redirect: req.query.redirect || "",
      paisos,
      data: {},
      errorMessages: [],
    });
  } catch (error) {
    next(error);
  }
});

// Otras rutas (login, logout, etc.)
router.post("/register", register);
// Ejemplo en src/routes/auth.js
router.get("/login", (req, res) => {
  res.render("auth/login", {
    redirect: req.query.redirect || "",
    reservationDetails: req.session.reservationDetails || null,
  });
});

router.post("/login", login);
router.get("/logout", logout);

export default router;
