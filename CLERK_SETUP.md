# Clerk Setup for InternPod (Dev)

## Step 1: Create Clerk Account

1. Go to https://clerk.com
2. Click **Sign up**
3. Create account with email
4. Verify email

## Step 2: Create InternPod Project

1. In Clerk dashboard, click **Create application**
2. Name it: `internpod-dev`
3. Choose authentication methods:
   - ✅ **Google** (required)
   - ✅ **Email/Password** (optional, for testing)
4. Click **Create application**

## Step 3: Get Your Keys

In your Clerk project dashboard:

1. Go to **API Keys** (left sidebar)
2. Copy these values:
   - **Publishable Key** — starts with `pk_test_` or `pk_live_`
   - **Secret Key** — starts with `sk_test_` or `sk_live_`

3. Add to `.env.local`:
```bash
CLERK_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxx
CLERK_SECRET_KEY=sk_test_xxxxxxxxxxxx
NEON_DATABASE_URL=postgresql://user:pass@pg.neon.tech/dbname
```

## Step 4: Configure Google OAuth in Clerk

1. In Clerk dashboard, go to **Social connections**
2. Click **Google**
3. You'll see Clerk's pre-configured Google OAuth (no setup needed)
4. Click **Enable**

## Step 5: Set Redirect URLs

In Clerk dashboard → **Settings** → **URLs**:

**Development:**
- Allowed redirect URLs: `http://localhost:3000/*`
- Allowed sign-out URLs: `http://localhost:3000`

**Production (later):**
- Allowed redirect URLs: `https://yourdomain.com/*`
- Allowed sign-out URLs: `https://yourdomain.com`

## Step 6: Verify Setup

1. Go to **Users** tab in Clerk dashboard
2. Should be empty (no users yet)
3. This is where you'll see users after they sign up

## Next Steps

Once Clerk is set up:
1. Build Vercel API endpoints (`/api/auth/sync`, etc.)
2. Update frontend to use Clerk instead of Supabase
3. Test signup flow

## Clerk Documentation

- **Getting started**: https://clerk.com/docs/quickstarts/nextjs
- **Google OAuth**: https://clerk.com/docs/authentication/social-connections/google
- **API reference**: https://clerk.com/docs/reference/backend-api
