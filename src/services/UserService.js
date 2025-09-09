// src/services/UserService.js
import { UserRepository } from '../repositories/UserRepository.js';
import prisma from '../config/prisma.js';
import bcrypt from 'bcrypt';

export class UserService {
  
  async registerUserWithClient(data) {
    return await prisma.$transaction(async (prismaTransaction) => {
      // Verificar si el nombre de usuario ya existe en usuaris
      const existingUser = await prismaTransaction.usuaris.findUnique({
        where: { email: data.email }
      });
      if (existingUser) {
        throw new Error("El EMAIL ya existe");
      }

      // Verificar si el DNI ya existe en clients
      const existingClient = await prismaTransaction.clients.findUnique({
        where: { dni: data.dni }
      });
      if (existingClient) {
        throw new Error("El DNI ya existe");
      }

      const fechaNacimiento = new Date(data.data_naixement);

      // Insertar datos en la tabla clients
      const client = await prismaTransaction.clients.create({
        data: {
          nom: data.nom,
          cognoms: data.cognoms,
          data_naixement: fechaNacimiento,
          dni: data.dni,
          email: data.email,
          telefon: data.telefon,
          carrer: data.carrer,
          numero: data.numero,
          pis: data.pis,
          codi_postal: data.codi_postal,
          ciutat: data.ciutat,
          idPais: parseInt(data.idPais),
          idProvincia: parseInt(data.idProvincia),
        },
      });

      // Insertar datos de acceso en la tabla usuaris
      const hashedPassword = await bcrypt.hash(data.password, 10);
      const user = await prismaTransaction.usuaris.create({
        data: {
          email: data.email,
          password: hashedPassword,
          idClient: client.idClient, // Se asocia el client recién creado
          // El campo rol se asigna automáticamente a "usuari" según la definición de la tabla.
        },
      });

      return { client, user };
    });
  }
}
