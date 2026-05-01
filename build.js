// Auth is handled by Clerk (embedded publishable key in HTML).
// API secrets (CLERK_SECRET_KEY, NEON_DATABASE_URL) live in Vercel env vars — no build step needed.

const required = ['CLERK_SECRET_KEY', 'NEON_DATABASE_URL']
const missing  = required.filter(k => !process.env[k])

if (missing.length) {
  console.warn(`Warning: Missing env vars: ${missing.join(', ')}`)
  console.warn('Set these in Vercel project settings (or .env.local for local dev).')
} else {
  console.log('✓ All required environment variables are set')
}
console.log('✓ Build complete — no static asset generation required')
