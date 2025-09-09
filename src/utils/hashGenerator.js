import bcrypt from 'bcrypt';
const saltRounds = 10; // Número de rondas de hashing

const password = "ronaldo"; // Contraseña en texto plano
bcrypt.hash(password, saltRounds, function(err, hash) {
    console.log(hash); // Muestra el hash generado
});