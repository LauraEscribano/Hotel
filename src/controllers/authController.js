// src/controllers/authController.js
import passport from 'passport';
import { UserService } from '../services/UserService.js';
import prisma from '../config/prisma.js';

const userService = new UserService();

export const login = (req, res, next) => {
  passport.authenticate('local', (err, user, info) => {    
    if (err) return next(err);
    if (!user) {
      req.flash('error', info.message);
      // Si hay redirect en el cuerpo, lo usamos, si no, lo intentamos en el query
      const redirectQuery = req.body.redirect || req.query.redirect ? `?redirect=${encodeURIComponent(req.body.redirect || req.query.redirect)}` : "";
      return res.redirect('/auth/login' + redirectQuery);
    }
     // Guardo la variable reservationDetails en una variable local para preservarla durante el login
     const tempReservation = req.session.reservationDetails;
    req.logIn(user, (err) => {
      if (err) return next(err);
      // Restaurar los detalles temporales de la reserva, si existen
      if (tempReservation) {
        req.session.reservationDetails = tempReservation;
      }      
      // Si se pasó redirect, lo usamos; si no, redirigimos a la ruta por defecto según el rol
      const redirectUrl = req.body.redirect || req.query.redirect || (user.rol === 'administrador' ? '/admin/dashboard' : '/user/profile');
      return res.redirect(redirectUrl);
    });
  })(req, res, next);
};



export const logout = (req, res, next) => {
  req.logout((err) => {
    if (err) return next(err);
    res.redirect('/home');
  });
};

export const register = async (req, res, next) => {
  const { redirect } = req.body;          // <-- recogemos redirec
  try {
    
    console.log('Datos recibidos en el registro:', req.body);

    const { user: createdUser } = await userService.registerUserWithClient(req.body);
    const tempReservation = req.session.reservationDetails;

    req.flash('success', 'Usuario registrado correctamente');
    // 2) Al registrar, hacemos login automático
    console.log('Usuario registrado:', createdUser);
    req.logIn(createdUser, err => {
      if (err) return next(err);

      if (tempReservation) {
        req.session.reservationDetails = tempReservation;
      }
      const redirectUrl = redirect || '/user/profile';
      // 3) Y redirigimos a donde tocaba (details u otra)
      return res.redirect(redirectUrl);
    });
    
  } catch (error) {
    req.flash('error', error.message);    
    // Leer el mensaje flash inmediatamente y pasarlo a la vista
    const errorMessages = req.flash('error');
    // También es recomendable volver a obtener la lista de países para repoblar el select
    const paisos = await prisma.paisos.findMany();
    res.render('auth/register', { 
      data: req.body, 
      errorMessages, 
      paisos,
      redirect  
    });
  }
};
