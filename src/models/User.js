// src/models/User.js
export class User {
    constructor({ idUsuari, idClient, username, email, password, rol, actiu, deleted_at, data_creacio }) {
      this.id = idUsuari;
      this.idClient = idClient;
      this.username = username;
      this.email = email;
      this.password = password;
      this.rol = rol;
      this.active = actiu;
      this.deletedAt = deleted_at;
      this.createdAt = data_creacio;
    }
  
    isAdmin() {
      return this.rol === 'admin';
    }
  }
  