// src/config/passport.js
import passport from 'passport';
import { Strategy as LocalStrategy } from 'passport-local';
import bcrypt from 'bcrypt';
import { UserRepository } from '../repositories/UserRepository.js';

const userRepository = new UserRepository();

passport.use(new LocalStrategy(
  {
    usernameField: 'email',
    passwordField: 'password'
  },
  async (email, password, done) => {
    try {
      const user = await userRepository.findByEmail(email);
      if (!user) {
        return done(null, false, { message: 'Datos incorrectos' });
      }
      const isValid = await bcrypt.compare(password, user.password);
      if (!isValid) {
        return done(null, false, { message: 'Datos incorrectos' });
      }
      return done(null, user);
    } catch (error) {
      return done(error);
    }
  }
));

passport.serializeUser((user, done) => {
  done(null, user.idUsuari || user.id);
});

passport.deserializeUser(async (id, done) => {
  try {
    const user = await userRepository.findById(id); 
    if (!user) return done(new Error('Usuario no encontrado'));

    // **Quitamos** el campo password por seguridad
    const { password, ...safeUser } = user;
    done(null, safeUser);
  } catch (err) {
    done(err);
  }
});

export default passport;
