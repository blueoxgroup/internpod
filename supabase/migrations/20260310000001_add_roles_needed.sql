-- Add roles_needed column to startup_profiles
ALTER TABLE public.startup_profiles
  ADD COLUMN IF NOT EXISTS roles_needed text;
