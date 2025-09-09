// src/controllers/resultsController.js
import { getResultsData } from "../services/resultsService.js";

export const getResults = async (req, res, next) => {
  try {
    const destination = req.query.destination;
    const checkIn = req.query["check-in"];
    const checkOut = req.query["check-out"];
    const roomsRequested = parseInt(req.query.rooms);
    const adults = req.query.adults;
    const children = req.query.children;

    if (
      !destination ||
      !checkIn ||
      !checkOut ||
      !adults ||
      isNaN(roomsRequested)
    ) {
      throw new Error(
        "Debe seleccionar un destino, fechas, capacidad y número de habitaciones"
      );
    }

    const requiredCapacity = parseInt(adults) + parseInt(children || "0");

    let resultsData = {};
    switch (true) {
      case destination.startsWith("hotel-"): {
        const hotelId = parseInt(destination.substring(6)); // "hotel-" tiene 6 caracteres
        if (isNaN(hotelId)) throw new Error("Destino inválido");
        resultsData = await getResultsData({
          type: "hotel",
          hotelId,
          checkIn,
          checkOut,
          requiredCapacity,
          roomsRequested,
        });
        break;
      }
      case destination.startsWith("city-"): {
        const groupValue = destination.substring(5); // Ejemplo: "city-España - Barcelona"
        const parts = groupValue.split(" - ");
        const city = parts.length > 1 ? parts[1].trim() : groupValue.trim();
        resultsData = await getResultsData({
          type: "city",
          city,
          checkIn,
          checkOut,
          requiredCapacity,
          roomsRequested,
        });
        break;
      }
      default:
        throw new Error("Destino inválido");
    }
    console.log("Resultados obtenidos:", resultsData);
    console.log("Detalles de la reserva:", {
      checkIn,
      checkOut,
      roomsRequested,
      requiredCapacity,
      adults,
      children,
    });
    res.render("general/results", {
      ...resultsData,
      checkIn,
      checkOut,
      roomsRequested,
      requiredCapacity,
      adults,
      children,
    });
  } catch (error) {
    next(error);
  }
};
