// src/repositories/UserRepository.js
import prisma from '../config/prisma.js';
import bcrypt from 'bcrypt';
import { User } from '../models/User.js';

export class UserRepository {

  async findByEmail(email) {
    const userData = await prisma.usuaris.findUnique({
      where: { email }
    });
    return userData ? new User(userData) : null;
  }

  async findById(id) {
    const userData = await prisma.usuaris.findUnique({
      where: { idUsuari: id }
    });
    return userData ? new User(userData) : null;
  }

  async createUser({ email, password}) {
    const hashedPassword = await bcrypt.hash(password, 10);
    const userData = await prisma.usuaris.create({
      data: {
        email,
        password: hashedPassword
      }
    });

    return new User(userData);
  }
}
