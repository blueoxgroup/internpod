-- Allow any authenticated user to read their own profile row.
-- Writes remain restricted to the owning user.
-- This prevents routeByRole() from hanging due to policy denial.
DROP POLICY IF EXISTS "users_own_profile" ON public.profiles;

CREATE POLICY "profiles_read_own" ON public.profiles
  FOR SELECT TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "profiles_write_own" ON public.profiles
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "profiles_delete_own" ON public.profiles
  FOR DELETE TO authenticated
  USING (auth.uid() = id);
