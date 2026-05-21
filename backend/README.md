# Laundry App Backend API

REST API for the Laundry App authentication system built with **Node.js + Express + PostgreSQL**.

## Prerequisites

- Node.js >= 18.0.0
- PostgreSQL >= 14
- npm or yarn

## Setup Instructions

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Configure Environment

```bash
cp .env.example .env
```

Edit `.env` with your actual values:
```
PORT=3000
NODE_ENV=development
DATABASE_URL=postgresql://postgres:yourpassword@localhost:5432/laundry_app
JWT_SECRET=your_super_secret_jwt_key_here
JWT_EXPIRES_IN=7d
CORS_ORIGIN=*
```

### 3. Create Database

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE laundry_app;
\q
```

### 4. Run Migration

```bash
psql -U postgres -d laundry_app -f migrations/001_create_users_table.sql
```

### 5. Start Server

```bash
# Development (auto-restart on changes)
npm run dev

# Production
npm start
```

---

## API Endpoints

| Method | Endpoint             | Auth | Description              |
|--------|----------------------|------|--------------------------|
| POST   | `/api/auth/register` | ❌   | Register a new user      |
| POST   | `/api/auth/login`    | ❌   | Login with credentials   |
| GET    | `/api/auth/me`       | ✅   | Get current user profile |
| GET    | `/api/health`        | ❌   | Health check             |

---

## API Reference

### Register

```http
POST /api/auth/register
Content-Type: application/json
```

**Request Body:**
```json
{
  "full_name": "Iqbal",
  "email": "iqbal@example.com",
  "phone_number": "+6281234567890",
  "password": "SecurePass123!"
}
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "Registrasi berhasil",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "full_name": "Iqbal",
      "email": "iqbal@example.com",
      "phone_number": "+6281234567890"
    }
  }
}
```

**Error Response (409):**
```json
{
  "success": false,
  "message": "Email sudah terdaftar"
}
```

---

### Login

```http
POST /api/auth/login
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "iqbal@example.com",
  "password": "SecurePass123!"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Login berhasil",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "full_name": "Iqbal",
      "email": "iqbal@example.com",
      "phone_number": "+6281234567890"
    }
  }
}
```

**Error Response (401):**
```json
{
  "success": false,
  "message": "Email atau kata sandi salah"
}
```

---

### Get Current User (Protected)

```http
GET /api/auth/me
Authorization: Bearer <token>
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Data user berhasil diambil",
  "data": {
    "user": {
      "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "full_name": "Iqbal",
      "email": "iqbal@example.com",
      "phone_number": "+6281234567890"
    }
  }
}
```

---

## Authentication Flow

```
┌─────────┐      ┌──────────┐      ┌──────────┐
│  Client  │─────▶│  Express │─────▶│PostgreSQL│
│ (Flutter)│◀─────│   API    │◀─────│    DB    │
└─────────┘      └──────────┘      └──────────┘

1. Register/Login → API validates → bcrypt hash → store/compare → generate JWT → return token
2. Protected routes → Bearer token → middleware verifies JWT → attach userId → controller → DB query
3. Auto-login → Flutter reads secure storage → sends GET /me with token → validates session
```

## Security

- Passwords hashed with **bcrypt** (12 salt rounds)
- JWT tokens with configurable expiry (default: 7 days)
- Input validation via **express-validator**
- SQL injection protection via **parameterized queries**
- CORS configured for allowed origins
