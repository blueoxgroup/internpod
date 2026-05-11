-- ─────────────────────────────────────────────────────────────
-- Blue Ox Jobs — Intern Moderation
-- Adds approval status to interns table.
--
-- Migration strategy for existing data:
--   • Interns already selected by a startup → approved
--   • Interns with a claimed user_id but no selection → approved
--     (they existed before moderation was introduced)
--   • Interns with no user_id (unclaimed seed rows) → pending
-- ─────────────────────────────────────────────────────────────

ALTER TABLE public.interns
  ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'approved', 'rejected'));

-- Auto-approve all interns that already have a user_id (signed up before moderation)
UPDATE public.interns
SET status = 'approved'
WHERE user_id IS NOT NULL;

-- Also approve any intern that has already been selected by a startup
UPDATE public.interns
SET status = 'approved'
WHERE id IN (SELECT intern_id FROM public.pod_selections);
