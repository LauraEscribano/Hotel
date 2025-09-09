// src/middlewares/roleMiddleware.js
export function ensureAdmin(req, res, next) {
  if (req.user && req.user.rol === 'administrador') {
    return next();
  }
  req.flash('error', 'Acceso denegado.');
  res.redirect('/auth/login');
}

export function ensureUser(req, res, next) {
  if (req.user && req.user.rol === 'usuari') {
    return next();
  }
  req.flash('error', 'Los administradores no pueden acceder a esta sección.');
  res.redirect('/');
}
  