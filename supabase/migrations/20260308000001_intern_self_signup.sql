-- ─────────────────────────────────────────────
-- 1. Clear all existing seeded data
-- ─────────────────────────────────────────────
TRUNCATE public.pod_selections CASCADE;
TRUNCATE public.interns CASCADE;

-- ─────────────────────────────────────────────
-- 2. Add user_id so each intern owns their row
-- ─────────────────────────────────────────────
ALTER TABLE public.interns
  ADD COLUMN IF NOT EXISTS user_id uuid references auth.users(id) on delete cascade;

ALTER TABLE public.interns
  ADD COLUMN IF NOT EXISTS linkedin text;

-- One profile per authenticated user
CREATE UNIQUE INDEX IF NOT EXISTS interns_user_id_idx ON public.interns(user_id);

-- ─────────────────────────────────────────────
-- 3. RLS — interns can manage their own profile
-- ─────────────────────────────────────────────

-- Allow interns to insert their own profile
CREATE POLICY "interns_insert_own" ON public.interns
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Allow interns to update their own profile
CREATE POLICY "interns_update_own" ON public.interns
  FOR UPDATE TO authenticated
  USING (auth.uid() = user_id);

-- Allow interns to delete their own profile
CREATE POLICY "interns_delete_own" ON public.interns
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);
