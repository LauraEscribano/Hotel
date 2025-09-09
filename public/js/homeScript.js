// Este script se encarga de manejar la lógica de fechas para el formulario de check-in y check-out
document.addEventListener("DOMContentLoaded", function () {
  const checkIn = document.getElementById("check-in");
  const checkOut = document.getElementById("check-out");

  // Verificar que los elementos existen
  if (!checkIn || !checkOut) {
    console.error("Elementos de formulario no encontrados");
    return;
  }

  // Función para obtener la fecha actual en formato YYYY-MM-DD (usando hora local)
  function getFormattedDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }

  // Función para obtener fecha siguiente
  function getNextDay(dateString) {
    const date = new Date(dateString);
    date.setDate(date.getDate() + 1);
    return getFormattedDate(date);
  }

  // Establecer fecha mínima para check-in (hoy)
  const today = getFormattedDate(new Date());
  checkIn.min = today;

  // Inicialización: establecer límites iniciales
  function initializeDates() {
    // Si check-in ya tiene una fecha, establecer check-out mínimo
    if (checkIn.value) {
      checkOut.min = getNextDay(checkIn.value);

      // Si el check-out tiene valor pero es anterior al mínimo, corregirlo
      if (checkOut.value && new Date(checkOut.value) < new Date(checkOut.min)) {
        checkOut.value = checkOut.min;
      }
    }
  }

  // Cuando cambia el check-in, actualizar check-out
  checkIn.addEventListener("change", function () {
    if (!this.value) {
      // Si se borra la fecha de check-in, resetear el mínimo de check-out
      checkOut.min = today;
      return;
    }

    // Validar que la fecha no sea anterior a hoy
    if (new Date(this.value) < new Date(today)) {
      //alert('La fecha de check-in no puede ser anterior a hoy');
      this.value = today;
    }

    // Establece el mínimo del check-out
    checkOut.min = getNextDay(this.value);

    // Si el check-out actual es anterior al nuevo mínimo, lo actualiza
    if (checkOut.value && new Date(checkOut.value) < new Date(checkOut.min)) {
      checkOut.value = checkOut.min;
    }

    // Automáticamente abrir el selector de check-out después de seleccionar check-in
    setTimeout(() => {
      checkOut.focus();
      // Intenta simular un clic en el input para abrir el calendario en navegadores que lo soportan
      try {
        checkOut.showPicker();
      } catch (e) {
        // showPicker no está soportado en todos los navegadores
        // El focus debería ser suficiente para la mayoría de los casos
      }
    }, 100);
  });

  // Validar también el check-out cuando cambia
  checkOut.addEventListener("change", function () {
    if (!this.value) return;

    const minDate = checkIn.value ? getNextDay(checkIn.value) : today;

    if (new Date(this.value) < new Date(minDate)) {
      //alert('La fecha de check-out debe ser posterior al check-in');
      this.value = minDate;
    }
  });

  // Inicializar al cargar
  initializeDates();
});

/*
 * Script
 */

window.addEventListener("scroll", () => {
  const button = document.getElementById("backToTop");
  button.style.display = window.scrollY > 500 ? "block" : "none";
});

document.getElementById("backToTop").addEventListener("click", () => {
  window.scrollTo({ top: 0, behavior: "smooth" });
});

/*
 * Script
 */

document.addEventListener("DOMContentLoaded", function () {
  // Coordenadas de cada destino
  const destinos = [
    {
      ciudad: "Barcelona",
      pais: "España",
      hoteles: ["Hotel Catalonia ★★★★", "Majestic Hotel & Spa Barcelona ★★★★★"],
      coord: [41.3851, 2.1734],
    },
    {
      ciudad: "Madrid",
      pais: "España",
      hoteles: ["Hotel Ritz Madrid ★★★★★", "NH Collection Madrid ★★★★"],
      coord: [40.4168, -3.7038],
    },
    {
      ciudad: "Ibiza",
      pais: "España",
      hoteles: ["Ibiza Beach Hotel ★★★★★"],
      coord: [38.9067, 1.4206],
    },
    {
      ciudad: "Las Palmas de Gran Canaria",
      pais: "España",
      hoteles: ["Santa Catalina Hotel ★★★★★"],
      coord: [28.1235, -15.4363],
    },
    {
      ciudad: "Mallorca",
      pais: "España",
      hoteles: ["Cap Rocat Mallorca ★★★★★"],
      coord: [39.6953, 3.0176],
    },
    {
      ciudad: "Hawaii",
      pais: "EEUU",
      hoteles: ["Four Seasons Resort Maui ★★★★★"],
      coord: [20.7984, -156.3319],
    },
    {
      ciudad: "Miami",
      pais: "EEUU",
      hoteles: ["Fontainebleau Miami Beach ★★★★★"],
      coord: [25.7907, -80.13],
    },
    {
      ciudad: "Cannes",
      pais: "Francia",
      hoteles: ["InterContinental Carlton Cannes ★★★★★"],
      coord: [43.5528, 7.0174],
    },
    {
      ciudad: "Suiza",
      pais: "Suiza",
      hoteles: ["Bellevue Palace Bern ★★★★★"],
      coord: [46.948, 7.4474],
    },
    {
      ciudad: "Budapest",
      pais: "Hungría",
      hoteles: ["Danube Royal Hotel ★★★★★"],
      coord: [47.4979, 19.0402],
    },
  ];

  // Inicializa el mapa centrado en Europa
  var map = L.map("mapa-destinos").setView([42, 4], 3.5);

  // Añade el mapa base
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: "&copy; OpenStreetMap contributors",
  }).addTo(map);

  // Añade los marcadores
  destinos.forEach((destino) => {
    let popupContent = `<strong>${destino.ciudad}</strong><br><em>${destino.pais}</em><br>`;
    popupContent += `<ul style="padding-left: 18px; margin: 0;">`;
    destino.hoteles.forEach((hotel) => {
      popupContent += `<li>${hotel}</li>`;
    });
    popupContent += `</ul>`;
    L.marker(destino.coord).addTo(map).bindPopup(popupContent);
  });
});

/*
 * Script
 */

document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll('.widget-clima-minimal').forEach(function (widget) {
    const ciudad = widget.getAttribute('data-ciudad');
    const url = `https://wttr.in/${encodeURIComponent(ciudad)}?format=%c+%t&lang=es`;
    fetch(url)
      .then(response => response.text())
      .then(data => {
        widget.innerHTML = `<span class="clima-info">${data.trim()}</span>`;
      })
      .catch(() => {
        widget.innerHTML = `<span class="clima-error">N/D</span>`;
      });
  });
});
/*
 * Script
 */

