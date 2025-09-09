import {
    getTotals,
    getMonthlyNewClients,
    getMonthlyReservations,
    getReservationsByHotel
  } from '../services/dashboardService.js';
  
  export const showDashboard = async (req, res, next) => {
    try {
      const [ totals, clientsChart, reservationsChart, byHotelChart ] =
        await Promise.all([
          getTotals(),
          getMonthlyNewClients(),
          getMonthlyReservations(),
          getReservationsByHotel()
        ]);
      res.render('admin/dashboard', {
        totals,
        clientsChart:      JSON.stringify(clientsChart),
        reservationsChart: JSON.stringify(reservationsChart),
        byHotelChart:      JSON.stringify(byHotelChart)
      });
    } catch (err) {
      next(err);
    }
  };
  