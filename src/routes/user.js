// src/routes/user.js
import express from 'express';
import { ensureAuthenticated } from '../middlewares/authMiddleware.js';
import { ensureUser } from '../middlewares/roleMiddleware.js';
import {
  showProfile,
  updateProfile
} from '../controllers/userProfileController.js';

const router = express.Router();

// Mostrar el perfil y las reservas
router.get(
  '/profile',
  ensureAuthenticated,
  ensureUser,
  showProfile
);

// Capturar el formulario de perfil para actualizar datos
router.post(
  '/profile',
  ensureAuthenticated,
  ensureUser,
  express.urlencoded({ extended: false }),
  updateProfile
);

export default router;
