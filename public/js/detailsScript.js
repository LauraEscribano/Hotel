// Este script se encarga de actualizar el precio total en la página de detalles
(function () {
    // Obtener la referencia a los elementos DOM
    const radios = document.querySelectorAll('.service-radio');
    const priceValueSpan = document.getElementById('priceValue');
    
    // Obtener valores necesarios
    // Ahora necesitamos obtener estos valores del DOM o como atributos data-
    const basePrice = parseFloat(document.getElementById('basePrice').value || 
                     document.getElementById('basePrice').dataset.value || 0);   
    
    function updatePrice() {
      const selected = document.querySelector('.service-radio:checked');
      const servicePrice = parseFloat(selected.dataset.preu);
                             
      priceValueSpan.textContent = (basePrice + servicePrice) + ' €';
    }
    
    radios.forEach(r => r.addEventListener('change', updatePrice));
    updatePrice();  // inicial
  })();