const { pool } = require('../config/database');

/**
 * Creates a new user in the database.
 * @param {object} userData - { full_name, email, phone_number, password_hash }
 * @returns {object} The created user (without password_hash).
 */
async function createUser({ full_name, email, phone_number, password_hash }) {
  const query = `
    INSERT INTO users (full_name, email, phone_number, password_hash)
    VALUES ($1, $2, $3, $4)
    RETURNING id, full_name, email, phone_number, created_at, updated_at
  `;
  const values = [full_name, email, phone_number, password_hash];
  const result = await pool.query(query, values);
  return result.rows[0];
}

/**
 * Finds a user by email address.
 * @param {string} email
 * @returns {object|null} User row (includes password_hash) or null.
 */
async function findByEmail(email) {
  const query = `
    SELECT id, full_name, email, phone_number, password_hash, profile_photo_url, created_at, updated_at
    FROM users
    WHERE email = $1 AND is_active = TRUE
  `;
  const result = await pool.query(query, [email]);
  return result.rows[0] || null;
}

/**
 * Finds a user by ID.
 * @param {string} id - UUID
 * @returns {object|null} User row (without password_hash) or null.
 */
async function findById(id) {
  const query = `
    SELECT id, full_name, email, phone_number, profile_photo_url, created_at, updated_at
    FROM users
    WHERE id = $1 AND is_active = TRUE
  `;
  const result = await pool.query(query, [id]);
  return result.rows[0] || null;
}

/**
 * Updates a user's password.
 * @param {string} id - UUID
 * @param {string} newPasswordHash
 * @returns {boolean}
 */
async function updatePassword(id, newPasswordHash) {
  const query = `
    UPDATE users
    SET password_hash = $2
    WHERE id = $1
  `;
  const result = await pool.query(query, [id, newPasswordHash]);
  return result.rowCount > 0;
}

/**
 * Updates a user's profile photo.
 * @param {string} id - UUID
 * @param {string} photoUrl
 * @returns {boolean}
 */
async function updateProfilePhoto(id, photoUrl) {
  const query = `
    UPDATE users
    SET profile_photo_url = $2
    WHERE id = $1
  `;
  const result = await pool.query(query, [id, photoUrl]);
  return result.rowCount > 0;
}

module.exports = { createUser, findByEmail, findById, updatePassword, updateProfilePhoto };
