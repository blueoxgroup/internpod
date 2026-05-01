# Neon Database Setup

Run these files in order in the Neon SQL editor.

## Order

| File | What it does |
|------|-------------|
| `01_schema.sql` | Creates all tables (interns, profiles, startup_profiles, pod_selections) |
| `02_seed.sql` | Inserts the original intern records |
| `03_rls.sql` | Row Level Security policies — **optional**, see note below |

## Key Differences from Supabase

- `user_id` fields are `text` not `uuid` — auth providers like Clerk use string IDs (e.g. `user_2abc123`)
- No dependency on `auth.users` table (Supabase-only)
- `auth.uid()` is replaced by `public.current_user_id()` which reads `app.current_user_id` from session settings

## RLS Note

If you are enforcing access control in your backend API (Fastify/Express middleware), you can **skip `03_rls.sql`** entirely.

If you want database-level RLS, your backend must set the user ID before each query:
```sql
SET LOCAL app.current_user_id = 'user_2abc123xyz';
```
