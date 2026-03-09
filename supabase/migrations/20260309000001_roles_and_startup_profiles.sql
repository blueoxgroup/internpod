-- ─────────────────────────────────────────────────────────────
-- 1. Profiles table — one row per user, tracks role
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id         uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  role       text NOT NULL CHECK (role IN ('intern', 'startup', 'admin')),
  email      text,
  created_at timestamptz DEFAULT now()
);

-- ─────────────────────────────────────────────────────────────
-- 2. Admin helper function (SECURITY DEFINER bypasses RLS)
--    Created AFTER the table so the reference resolves.
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT COALESCE(
    (SELECT role = 'admin' FROM public.profiles WHERE id = auth.uid() LIMIT 1),
    false
  )
$$;

-- ─────────────────────────────────────────────────────────────
-- 3. RLS on profiles
-- ─────────────────────────────────────────────────────────────
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "profiles_select_own" ON public.profiles
  FOR SELECT TO authenticated
  USING (auth.uid() = id OR public.is_admin());

CREATE POLICY "profiles_insert_own" ON public.profiles
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = id AND role IN ('intern', 'startup'));

CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE TO authenticated
  USING (auth.uid() = id AND role IN ('intern', 'startup'))
  WITH CHECK (auth.uid() = id AND role IN ('intern', 'startup'));

-- ─────────────────────────────────────────────────────────────
-- 4. Startup profiles table
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.startup_profiles (
  id           uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id      uuid REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  company_name text NOT NULL,
  website      text,
  description  text,
  industry     text,
  team_size    text,
  location     text,
  email        text,
  created_at   timestamptz DEFAULT now()
);

ALTER TABLE public.startup_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "startup_own_rw" ON public.startup_profiles
  FOR ALL TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "startup_admin_all" ON public.startup_profiles
  FOR ALL TO authenticated
  USING (public.is_admin());

-- ─────────────────────────────────────────────────────────────
-- 5. Admin policies on interns and pod_selections
-- ─────────────────────────────────────────────────────────────
CREATE POLICY "interns_admin_all" ON public.interns
  FOR ALL TO authenticated
  USING (public.is_admin());

CREATE POLICY "pod_admin_all" ON public.pod_selections
  FOR ALL TO authenticated
  USING (public.is_admin());
