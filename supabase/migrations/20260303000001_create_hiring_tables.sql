-- ─────────────────────────────────────────────
-- INTERNS TABLE
-- ─────────────────────────────────────────────
create table if not exists public.interns (
  id                    uuid default gen_random_uuid() primary key,
  name                  text not null,
  email                 text,
  location              text,
  whatsapp              text,
  main_skill            text,
  skills_detail         text,
  github                text,
  portfolio             text,
  availability          text,
  preferred_start_date  text,
  english_level         text,
  timezones             text,
  project_description   text,
  created_at            timestamptz default now()
);

-- ─────────────────────────────────────────────
-- POD SELECTIONS TABLE
-- Tracks which startup selected which interns.
-- unique(intern_id) ensures each intern is in at most one pod globally.
-- ─────────────────────────────────────────────
create table if not exists public.pod_selections (
  id             uuid default gen_random_uuid() primary key,
  startup_id     uuid references auth.users(id) on delete cascade not null,
  startup_email  text,
  startup_name   text,
  intern_id      uuid references public.interns(id) on delete cascade not null,
  confirmed      boolean default false,
  created_at     timestamptz default now(),
  unique(intern_id)
);

-- ─────────────────────────────────────────────
-- ROW LEVEL SECURITY
-- ─────────────────────────────────────────────
alter table public.interns          enable row level security;
alter table public.pod_selections   enable row level security;

-- Interns: any authenticated user can read
create policy "interns_select" on public.interns
  for select to authenticated using (true);

-- Pod selections: any authenticated user can read (to see who is taken)
create policy "pod_select_all" on public.pod_selections
  for select to authenticated using (true);

-- Pod selections: startups can insert their own selections
create policy "pod_insert_own" on public.pod_selections
  for insert to authenticated
  with check (auth.uid() = startup_id);

-- Pod selections: startups can update their own selections (e.g. set confirmed=true)
create policy "pod_update_own" on public.pod_selections
  for update to authenticated
  using (auth.uid() = startup_id);

-- Pod selections: startups can delete (deselect) their own unconfirmed picks
create policy "pod_delete_own" on public.pod_selections
  for delete to authenticated
  using (auth.uid() = startup_id and confirmed = false);
