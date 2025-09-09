(function () {
  const pass1 = document.getElementById('password');
  const pass2 = document.getElementById('password2');
  const bar = document.getElementById('pwdMeter');
  const msg = document.getElementById('pwdMsg');

  function score(pwd) {
    let s = 0;
    if (pwd.length >= 8) s++;
    if (/[A-Z]/.test(pwd)) s++;
    if (/[a-z]/.test(pwd)) s++;
    if (/\d/.test(pwd)) s++;
    if (/[^A-Za-z0-9]/.test(pwd)) s++;
    return Math.min(s, 4);      // 0-4
  }

  function updateStrength() {
    const sc = score(pass1.value);
    bar.style.width = (sc * 25) + '%';
    bar.setAttribute('aria-valuenow', sc);

    // quitar clases anteriores  bar-0…bar-4
    bar.className = 'progress-bar bar-' + sc;

    const labels = [' Muy débil', ' Débil', ' Aceptable', ' Fuerte', ' Muy fuerte'];
    msg.textContent = 'Seguridad: ' + labels[sc];
  }

  function checkMatch() {
    if (pass2.value && pass1.value !== pass2.value) {
      pass2.classList.add('is-invalid');
    } else {
      pass2.classList.remove('is-invalid');
    }
  }

  pass1.addEventListener('input', () => { updateStrength(); checkMatch(); });
  pass2.addEventListener('input', checkMatch);
  updateStrength();          
})();

/**
 * Script
 */

const togglePassword = document.querySelector("#togglePassword");
const password = document.querySelector("#password");
const eyeIcon = document.querySelector("#eyeIcon");

togglePassword.addEventListener("click", function () {
  // Toggle del tipo de input
  const type =
    password.getAttribute("type") === "password" ? "text" : "password";
  password.setAttribute("type", type);

  // Cambiar el icono
  eyeIcon.classList.toggle("bi-eye");
  eyeIcon.classList.toggle("bi-eye-slash");
});