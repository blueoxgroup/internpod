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
      `SELECT i.*, ps.startup_name, ps.confirmed
       FROM public.interns i
       LEFT JOIN public.pod_selections ps ON ps.intern_id = i.id
       ORDER BY i.created_at DESC`
    )

    return res.status(200).json(rows)
  } catch (err) {
    return res.status(err.status || 500).json({ error: err.message })
  }
}
