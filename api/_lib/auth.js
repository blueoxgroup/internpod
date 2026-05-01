const { verifyToken } = require('@clerk/backend')

async function requireAuth(req) {
  const header = req.headers['authorization'] || ''
  const token = header.startsWith('Bearer ') ? header.slice(7) : header

  if (!token) {
    const err = new Error('Unauthorized')
    err.status = 401
    throw err
  }

  try {
    const payload = await verifyToken(token, {
      secretKey: process.env.CLERK_SECRET_KEY,
    })
    return { userId: payload.sub, payload }
  } catch {
    const err = new Error('Invalid or expired token')
    err.status = 401
    throw err
  }
}

async function requireAdmin(req, db) {
  const auth = await requireAuth(req)
  const { rows } = await db.query(
    'SELECT role FROM public.profiles WHERE id = $1',
    [auth.userId]
  )
  if (!rows[0] || rows[0].role !== 'admin') {
    const err = new Error('Forbidden')
    err.status = 403
    throw err
  }
  return auth
}

module.exports = { requireAuth, requireAdmin }
