// src/controllers/reservationController.js
import { getClientDataByUser } from "../services/clientService.js";
import {
  getHotelServices,
  makeReservation,
} from "../services/reservationService.js";

/**
 * GET /reservation/details
 * Pantalla penúltima: repasa los datos antes de confirmar.
 * Renderiza `reservation/details.ejs` pasando:
 *   - reservation
 *   - hotelServices
 *   - clientData
 *   - isAuthenticated
 */
export const showReservationDetails = async (req, res, next) => {
  try {
    const reservation = req.session.reservationDetails;
    if (!reservation) {
      req.flash("error", "No hay detalles de la reserva en proceso.");
      return res.redirect("/home");
    }

    const isAuthenticated = req.isAuthenticated() && !!req.user;
    const clientData = isAuthenticated
      ? await getClientDataByUser(req.user.id)
      : null;

    const hotelServices = await getHotelServices(
      parseInt(reservation.hotelId, 10),
      parseInt(reservation.rooms, 10),
      parseInt(reservation.nights, 10)
    );

    return res.render("reservation/details", {
      reservation,
      hotelServices,
      clientData,
      isAuthenticated,
      error: req.flash("error"),
      success: req.flash("success"),
    });
  } catch (err) {
    next(err);
  }
};

/**
 * POST /reservation/confirm
 * Procesa la reserva, guarda los datos necesarios en session y redirige
 * al GET /reservation/confirmation.
 */
export const confirmReservationDetails = async (req, res, next) => {
  try {
    const temp = req.session.reservationDetails;
    if (!temp) {
      throw new Error("No se encontraron detalles de la reserva en la sesión.");
    }

    // 1) Recoger servicios seleccionados
    let services = req.body.selectedServices || [];
    services = Array.isArray(services)
      ? services.map(Number)
      : [Number(services)];

    // 2) Preparamos payload para makeReservation
    const reservationData = {
      hotelId:          parseInt(temp.hotelId, 10),
      idCategoria:      parseInt(temp.idCategoria, 10),
      checkIn:          temp.checkIn,
      checkOut:         temp.checkOut,
      guests:           parseInt(temp.guests, 10),
      roomsRequested:   parseInt(temp.rooms, 10),
      requiredCapacity: parseInt(temp.guests, 10),
      selectedServices: services,
      clientId:         req.user?.idClient ?? null,
    };

    // 3) Ejecutar la reserva y obtener código
    const { code } = await makeReservation(reservationData);

    // 4) Preparar el objeto summary y demás variables para confirmation.ejs
    const summary = {
      roomCategory: temp.nomCategoria,
      checkIn:      temp.checkIn,
      checkOut:     temp.checkOut,
      guests:       temp.guests,
      rooms:        temp.rooms,
      nights:       temp.nights,
      roomsPrice:   temp.totalPrice,
    };

    const clientData = req.isAuthenticated()
      ? await getClientDataByUser(req.user.id)
      : null;

    const hotelServices = await getHotelServices(
      parseInt(reservationData.hotelId, 10),
      parseInt(summary.rooms, 10),
      parseInt(summary.nights, 10)
    );

    const selected = hotelServices.filter((s) =>
      services.includes(s.idServei)
    );
    const servicesPrice = selected.reduce((sum, s) => sum + Number(s.preu), 0);

    const totalPrice = parseInt(summary.roomsPrice, 10) + servicesPrice;

    // 5) Guardamos **exactamente** las mismas variables que espera tu confirmation.ejs
    req.session.confirmationData = {
      code,
      summary,
      services,
      hotelServices,
      servicesPrice,
      totalPrice,
      clientData,
    };

    // 6) Limpiar la sesión de la reserva en curso
    delete req.session.reservationDetails;

    // 7) Redirigir a la pantalla final
    return res.redirect("/reservation/confirmation");
  } catch (err) {
    req.flash("error", err.message);
    return res.redirect("/reservation/details");
  }
};

/**
 * GET /reservation/confirmation
 * Muestra `confirmation.ejs` solo si hay datos en sesión, luego los limpia.
 */
export const showConfirmation = (req, res, next) => {
  try {
    const data = req.session.confirmationData;
    if (!data) {
      req.flash("error", "No hay datos de reserva para confirmar.");
      return res.redirect("/reservation/details");
    }

    // Evitar cache para que BACK no muestre copia
    res.setHeader(
      "Cache-Control",
      "no-store, no-cache, must-revalidate, private"
    );
    res.setHeader("Pragma", "no-cache");

    // Renderizamos con las propiedades originales:
    //   code, summary, services, hotelServices, servicesPrice, totalPrice, clientData
    res.render("reservation/confirmation", data);

    // Limpiamos para que no se pueda volver atrás
    delete req.session.confirmationData;
  } catch (err) {
    next(err);
  }
};
