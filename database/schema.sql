-- =============================================================
-- Dev Profiler – PostgreSQL Database Schema
-- =============================================================
-- Run this script against a PostgreSQL 14+ database to initialise
-- the tables required by the Dev Profiler application.
-- =============================================================

-- Enable the uuid-ossp extension for UUID generation.
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -------------------------------------------------------------
-- Users
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id          UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        VARCHAR(120) NOT NULL,
    email       VARCHAR(255) NOT NULL UNIQUE,
    -- bcrypt hash of the user password
    password    TEXT         NOT NULL,
    role        VARCHAR(20)  NOT NULL CHECK (role IN ('admin', 'developer')),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);

-- -------------------------------------------------------------
-- Quizzes
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS quizzes (
    id          UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    title       VARCHAR(200) NOT NULL,
    description TEXT         NOT NULL DEFAULT '',
    created_by  UUID         REFERENCES users (id) ON DELETE SET NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- -------------------------------------------------------------
-- Questions
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS questions (
    id                   UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    quiz_id              UUID         NOT NULL REFERENCES quizzes (id) ON DELETE CASCADE,
    text                 TEXT         NOT NULL,
    -- JSON array of option strings, e.g. ["Option A", "Option B", ...]
    options              JSONB        NOT NULL,
    correct_option_index SMALLINT     NOT NULL CHECK (correct_option_index >= 0),
    position             SMALLINT     NOT NULL DEFAULT 0,
    created_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_questions_quiz_id ON questions (quiz_id);

-- -------------------------------------------------------------
-- Quiz Results
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS quiz_results (
    id              UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    quiz_id         UUID         NOT NULL REFERENCES quizzes (id) ON DELETE CASCADE,
    score           SMALLINT     NOT NULL CHECK (score >= 0),
    total_questions SMALLINT     NOT NULL CHECK (total_questions > 0),
    -- JSON object mapping question_id -> selected_option_index
    answers         JSONB        NOT NULL DEFAULT '{}',
    completed_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_results_user_id ON quiz_results (user_id);
CREATE INDEX IF NOT EXISTS idx_results_quiz_id ON quiz_results (quiz_id);

-- -------------------------------------------------------------
-- Trigger: auto-update updated_at columns
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE OR REPLACE TRIGGER trg_quizzes_updated_at
    BEFORE UPDATE ON quizzes
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- -------------------------------------------------------------
-- Seed data (optional – remove in production)
-- -------------------------------------------------------------
-- Admin user (password: Admin1234 – change immediately)
INSERT INTO users (name, email, password, role) VALUES
    ('Admin User', 'admin@devprofiler.example.com',
     '$2b$12$exampleHashReplaceThisInProduction000000000000000000000',
     'admin')
ON CONFLICT (email) DO NOTHING;
