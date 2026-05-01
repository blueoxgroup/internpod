const { requireAuth } = require('../_lib/auth')
const { getPool } = require('../_lib/db')

module.exports = async function handler(req, res) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' })
  }

  try {
    const { userId } = await requireAuth(req)
    const db = getPool()

    const { rows: profileRows } = await db.query(
      'SELECT * FROM public.profiles WHERE id = $1',
      [userId]
    )

    if (!profileRows[0]) {
      return res.status(404).json({ error: 'Profile not found. Call /api/auth/sync first.' })
    }

    const profile = profileRows[0]
    let data = null

    if (profile.role === 'intern') {
      const { rows } = await db.query(
        'SELECT * FROM public.interns WHERE user_id = $1',
        [userId]
      )
      data = rows[0] || null
    }

    if (profile.role === 'startup') {
      const { rows } = await db.query(
        'SELECT * FROM public.startup_profiles WHERE user_id = $1',
        [userId]
      )
      data = rows[0] || null
    }

    return res.status(200).json({ profile, data })
  } catch (err) {
    return res.status(err.status || 500).json({ error: err.message })
  }
}
