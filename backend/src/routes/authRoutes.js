const express = require('express');
const router = express.Router();

const multer = require('multer');
const path = require('path');

const {
  register,
  login,
  getMe,
  changePassword,
  changeProfilePhoto,
  registerValidation,
  loginValidation,
  passwordValidation,
} = require('../controllers/authController');
const { authMiddleware } = require('../middleware/authMiddleware');

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(__dirname, '../../uploads/'));
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});
const upload = multer({ storage: storage });

// Public routes
router.post('/register', registerValidation, register);
router.post('/login', loginValidation, login);

// Protected routes
router.get('/me', authMiddleware, getMe);
router.put('/password', authMiddleware, passwordValidation, changePassword);
router.put('/profile-photo', authMiddleware, upload.single('photo'), changeProfilePhoto);

module.exports = router;
