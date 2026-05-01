-- ─────────────────────────────────────────────────────────────
-- Blue Ox Jobs — Neon Schema
-- Adapted from Supabase migrations for plain PostgreSQL (Neon)
--
-- Key differences from Supabase:
--   • user_id / profile id fields are TEXT not UUID
--     because most auth providers (Clerk, Auth0) use string IDs
--     e.g. Clerk: 'user_2abc123xyz'
--   • No references to auth.users (Supabase-only table)
--   • RLS is in 03_rls.sql — run separately once auth is wired up
-- ─────────────────────────────────────────────────────────────


-- ─────────────────────────────────────────────
-- INTERNS TABLE
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.interns (
  id                    uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id               text UNIQUE,
  name                  text NOT NULL,
  email                 text,
  location              text,
  whatsapp              text,
  main_skill            text,
  skills_detail         text,
  github                text,
  portfolio             text,
  linkedin              text,
  availability          text,
  preferred_start_date  text,
  english_level         text,
  timezones             text,
  project_description   text,
  created_at            timestamptz DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS interns_user_id_idx ON public.interns(user_id);


-- ─────────────────────────────────────────────
-- PROFILES TABLE
-- One row per user — tracks their role
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id         text PRIMARY KEY,
  role       text NOT NULL CHECK (role IN ('intern', 'startup', 'admin')),
  email      text,
  created_at timestamptz DEFAULT now()
);


-- ─────────────────────────────────────────────
-- STARTUP PROFILES TABLE
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.startup_profiles (
  id           uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id      text UNIQUE NOT NULL,
  company_name text NOT NULL,
  website      text,
  description  text,
  industry     text,
  team_size    text,
  location     text,
  email        text,
  roles_needed text,
  created_at   timestamptz DEFAULT now()
);


-- ─────────────────────────────────────────────
-- POD SELECTIONS TABLE
-- Tracks which startup selected which interns.
-- unique(intern_id) ensures each intern is in at most one pod.
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.pod_selections (
  id             uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  startup_id     text NOT NULL,
  startup_email  text,
  startup_name   text,
  intern_id      uuid REFERENCES public.interns(id) ON DELETE CASCADE NOT NULL,
  confirmed      boolean DEFAULT false,
  created_at     timestamptz DEFAULT now(),
  UNIQUE(intern_id)
);
