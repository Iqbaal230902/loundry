const bcrypt = require('bcryptjs');
const { validationResult, body } = require('express-validator');
const { createUser, findByEmail, findById } = require('../models/userModel');
const { generateToken } = require('../utils/tokenUtils');

// Validation rules
const registerValidation = [
  body('full_name')
    .trim()
    .notEmpty().withMessage('Nama lengkap wajib diisi')
    .isLength({ min: 3 }).withMessage('Nama minimal 3 karakter'),
  body('email')
    .trim()
    .notEmpty().withMessage('Email wajib diisi')
    .isEmail().withMessage('Format email tidak valid')
    .normalizeEmail(),
  body('phone_number')
    .trim()
    .notEmpty().withMessage('Nomor telepon wajib diisi')
    .matches(/^\+?[0-9]{10,15}$/).withMessage('Format nomor telepon tidak valid'),
  body('password')
    .notEmpty().withMessage('Kata sandi wajib diisi')
    .isLength({ min: 8 }).withMessage('Kata sandi minimal 8 karakter')
    .matches(/[A-Z]/).withMessage('Kata sandi harus mengandung huruf besar')
    .matches(/[0-9]/).withMessage('Kata sandi harus mengandung angka')
    .matches(/[!@#$%^&*(),.?":{}|<>]/).withMessage('Kata sandi harus mengandung karakter spesial'),
];

const loginValidation = [
  body('email')
    .trim()
    .notEmpty().withMessage('Email wajib diisi')
    .isEmail().withMessage('Format email tidak valid')
    .normalizeEmail(),
  body('password')
    .notEmpty().withMessage('Kata sandi wajib diisi'),
];

/**
 * POST /api/auth/register
 */
async function register(req, res) {
  try {
    // Check validation
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      const firstError = errors.array()[0].msg;
      return res.status(400).json({
        success: false,
        message: firstError,
        errors: errors.array(),
      });
    }

    const { full_name, email, phone_number, password } = req.body;

    // Check if email already exists
    const existingUser = await findByEmail(email);
    if (existingUser) {
      return res.status(409).json({
        success: false,
        message: 'Email sudah terdaftar',
      });
    }

    // Hash password
    const salt = await bcrypt.genSalt(12);
    const password_hash = await bcrypt.hash(password, salt);

    // Create user
    const user = await createUser({
      full_name,
      email,
      phone_number,
      password_hash,
    });

    // Generate token
    const token = generateToken(user.id);

    return res.status(201).json({
      success: true,
      message: 'Registrasi berhasil',
      data: {
        token,
        user: {
          id: user.id,
          full_name: user.full_name,
          email: user.email,
          phone_number: user.phone_number,
        },
      },
    });
  } catch (error) {
    console.error('Register error:', error);
    return res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan pada server',
    });
  }
}

/**
 * POST /api/auth/login
 */
async function login(req, res) {
  try {
    // Check validation
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      const firstError = errors.array()[0].msg;
      return res.status(400).json({
        success: false,
        message: firstError,
        errors: errors.array(),
      });
    }

    const { email, password } = req.body;

    // Find user
    const user = await findByEmail(email);
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Email atau kata sandi salah',
      });
    }

    // Compare password
    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Email atau kata sandi salah',
      });
    }

    // Generate token
    const token = generateToken(user.id);

    return res.status(200).json({
      success: true,
      message: 'Login berhasil',
      data: {
        token,
        user: {
          id: user.id,
          full_name: user.full_name,
          email: user.email,
          phone_number: user.phone_number,
        },
      },
    });
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan pada server',
    });
  }
}

/**
 * GET /api/auth/me (protected)
 */
async function getMe(req, res) {
  try {
    const user = await findById(req.userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User tidak ditemukan',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Data user berhasil diambil',
      data: {
        user: {
          id: user.id,
          full_name: user.full_name,
          email: user.email,
          phone_number: user.phone_number,
        },
      },
    });
  } catch (error) {
    console.error('GetMe error:', error);
    return res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan pada server',
    });
  }
}

module.exports = {
  register,
  login,
  getMe,
  registerValidation,
  loginValidation,
};
