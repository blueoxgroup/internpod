-- ─────────────────────────────────────────────────────────────
-- Blue Ox Jobs — Row Level Security for Neon
-- Run this AFTER 01_schema.sql
--
-- HOW THIS WORKS WITH YOUR AUTH PROVIDER (Clerk / Auth0 / etc):
--   Your backend API must set the current user ID before each query:
--     SET LOCAL app.current_user_id = 'user_2abc123xyz';
--   This replaces Supabase's auth.uid() function.
--
-- If you handle auth entirely in the backend (recommended for this
-- project), you can SKIP this file and enforce access rules in
-- your Fastify/Express middleware instead. That is simpler and
-- easier to test.
-- ─────────────────────────────────────────────────────────────


-- ─────────────────────────────────────────────
-- Helper function — replaces Supabase auth.uid()
-- ─────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.current_user_id()
RETURNS text
LANGUAGE sql
STABLE
AS $$
  SELECT current_setting('app.current_user_id', true)
$$;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT COALESCE(
    (SELECT role = 'admin' FROM public.profiles WHERE id = public.current_user_id() LIMIT 1),
    false
  )
$$;


-- ─────────────────────────────────────────────
-- Enable RLS on all tables
-- ─────────────────────────────────────────────
ALTER TABLE public.interns          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.startup_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pod_selections   ENABLE ROW LEVEL SECURITY;


-- ─────────────────────────────────────────────
-- INTERNS policies
-- ─────────────────────────────────────────────
CREATE POLICY "interns_select_all" ON public.interns
  FOR SELECT USING (true);

CREATE POLICY "interns_insert_own" ON public.interns
  FOR INSERT WITH CHECK (public.current_user_id() = user_id);

CREATE POLICY "interns_update_own" ON public.interns
  FOR UPDATE USING (public.current_user_id() = user_id);

CREATE POLICY "interns_delete_own" ON public.interns
  FOR DELETE USING (public.current_user_id() = user_id);

CREATE POLICY "interns_admin_all" ON public.interns
  FOR ALL USING (public.is_admin());


-- ─────────────────────────────────────────────
-- PROFILES policies
-- ─────────────────────────────────────────────
CREATE POLICY "profiles_read_own" ON public.profiles
  FOR SELECT USING (public.current_user_id() = id OR public.is_admin());

CREATE POLICY "profiles_write_own" ON public.profiles
  FOR INSERT WITH CHECK (public.current_user_id() = id);

CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE
  USING (public.current_user_id() = id)
  WITH CHECK (public.current_user_id() = id);

CREATE POLICY "profiles_delete_own" ON public.profiles
  FOR DELETE USING (public.current_user_id() = id);


-- ─────────────────────────────────────────────
-- STARTUP PROFILES policies
-- ─────────────────────────────────────────────
CREATE POLICY "startup_own_rw" ON public.startup_profiles
  FOR ALL
  USING (public.current_user_id() = user_id)
  WITH CHECK (public.current_user_id() = user_id);

CREATE POLICY "startup_admin_all" ON public.startup_profiles
  FOR ALL USING (public.is_admin());


-- ─────────────────────────────────────────────
-- POD SELECTIONS policies
-- ─────────────────────────────────────────────
CREATE POLICY "pod_select_all" ON public.pod_selections
  FOR SELECT USING (true);

CREATE POLICY "pod_insert_own" ON public.pod_selections
  FOR INSERT WITH CHECK (public.current_user_id() = startup_id);

CREATE POLICY "pod_update_own" ON public.pod_selections
  FOR UPDATE USING (public.current_user_id() = startup_id);

CREATE POLICY "pod_delete_own" ON public.pod_selections
  FOR DELETE USING (public.current_user_id() = startup_id AND confirmed = false);

CREATE POLICY "pod_admin_all" ON public.pod_selections
  FOR ALL USING (public.is_admin());
