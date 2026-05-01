const { requireAdmin } = require('../_lib/auth')
const { getPool } = require('../_lib/db')

module.exports = async function handler(req, res) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' })
  }

  try {
    const db = getPool()
    await requireAdmin(req, db)

    const { rows } = await db.query(
      `SELECT sp.*,
        (SELECT COUNT(*) FROM public.pod_selections ps WHERE ps.startup_id = sp.user_id) as selection_count,
        (SELECT COUNT(*) FROM public.pod_selections ps WHERE ps.startup_id = sp.user_id AND ps.confirmed = true) as confirmed_count
       FROM public.startup_profiles sp
       ORDER BY sp.created_at DESC`
    )

    return res.status(200).json(rows)
  } catch (err) {
    return res.status(err.status || 500).json({ error: err.message })
  }
}
