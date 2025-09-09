// src/app.js
import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import session from 'express-session';
import flash from 'connect-flash';
import passport from './config/passport.js';
import dotenv from 'dotenv';

//routes
import homeRoutes from './routes/home.js';
import authRoutes from './routes/auth.js';
import userRoutes from './routes/user.js';
import adminRoutes from './routes/admin.js';
import apiRoutes from './routes/api/apiProvincias.js';
import resultsRoutes from './routes/results.js';
import reservationRoutes from './routes/reservation.js';
import reservationDetailsRoutes from './routes/reservation/reservationDetails.js';


dotenv.config();

const app = express();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use(express.static(path.join(__dirname, '..', 'public')));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: { maxAge: 60 * 60 * 1000 } // 1 hora
}));
app.use(flash());

app.use(passport.initialize());
app.use(passport.session());

app.use((req, res, next) => {
  res.locals.messages = {
    success: req.flash('success'),
    error: req.flash('error')
  };
  next();
});

// Middleware para pasar el usuario a las vistas
app.use((req, res, next) => {
  res.locals.user = req.user;
  next();
});


app.use('/', homeRoutes);
app.use('/auth', authRoutes);
app.use('/user', userRoutes);
app.use('/admin', adminRoutes);
app.use('/api', apiRoutes);
app.use('/results', resultsRoutes);
app.use('/reservation', reservationRoutes);
app.use('/reservation', reservationDetailsRoutes);


app.use((req, res, next) => {
  res.status(404).render('general/404');
});

app.locals.formatDate = (date) => {
  return new Date(date).toLocaleDateString('es-ES', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  });
};

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor corriendo en el puerto ${PORT}`));
