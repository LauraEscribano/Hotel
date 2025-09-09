// src/middlewares/errorHandler.js
export function errorHandler(err, req, res, next) {
    console.error(err.stack);
    res.status(500).render('error', { error: err });
  }
  