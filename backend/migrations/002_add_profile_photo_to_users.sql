-- ============================================
-- Laundry App - Add Profile Photo to Users
-- PostgreSQL
-- ============================================

ALTER TABLE users 
ADD COLUMN IF NOT EXISTS profile_photo_url VARCHAR(255);
