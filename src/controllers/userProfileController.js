import {
    getClientProfile,
    updateClientProfile,
    getActiveReservations,
    getReservationHistory, getCountries
  } from '../services/userProfileService.js';
  
  export const showProfile = async (req, res, next) => {
    try {
      const idClient = req.user.idClient;
      const [profile, active, history, countries] = await Promise.all([
        getClientProfile(idClient),
        getActiveReservations(idClient),
        getReservationHistory(idClient),
        getCountries()
      ]);
      res.render('user/profile', {
        profile,
        activeReservations: active,
        historyReservations: history,
        countries,
        success: req.flash('success'),
        error: req.flash('error')
      });       
    } catch (err) {
      next(err);
    }
  };
  
  export const updateProfile = async (req, res, next) => {
    try {
      const idClient = req.user.idClient;
      const updated = await updateClientProfile(idClient, req.body);
      req.flash('success', 'Perfil actualizado correctamente.');
      res.redirect('/user/profile#perfil');
    } catch (err) {
      req.flash('error', 'Error al actualizar el perfil.');
      res.redirect('/user/profile#perfil');
    }    
  };
  