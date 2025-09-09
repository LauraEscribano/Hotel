// public/js/provincias.js
document.getElementById('idPais').addEventListener('change', async function() {
    const paisId = this.value;
    const provinciaSelect = document.getElementById('idProvincia');
    
    // Muestra un mensaje mientras se cargan las provincias
    provinciaSelect.innerHTML = '<option value="">Cargando provincias...</option>';
    
    try {
      const response = await fetch(`/api/provincias?paisId=${paisId}`);
      if (!response.ok) throw new Error('Error al cargar provincias');
      
      const provincias = await response.json();
      
      // Limpia y repuebla el select
      provinciaSelect.innerHTML = '<option value="" disabled selected>Seleccione una provincia</option>';
      provincias.forEach(function(provincia) {
        const option = document.createElement('option');
        option.value = provincia.idProvincia; // Ajusta según el nombre de tu campo
        option.textContent = provincia.provincia;     // Ajusta según el nombre de tu campo
        provinciaSelect.appendChild(option);
      });
    } catch (error) {
      provinciaSelect.innerHTML = '<option value="">Error al cargar provincias</option>';
      console.error(error);
    }
  });
  