-- Add optional phone number to startup profiles
ALTER TABLE public.startup_profiles
  ADD COLUMN IF NOT EXISTS phone text;
