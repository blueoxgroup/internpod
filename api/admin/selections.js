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
      `SELECT
        ps.*,
        i.name as intern_name,
        i.email as intern_email,
        i.main_skill,
        i.location as intern_location
       FROM public.pod_selections ps
       JOIN public.interns i ON ps.intern_id = i.id
       ORDER BY ps.created_at DESC`
    )

    return res.status(200).json(rows)
  } catch (err) {
    return res.status(err.status || 500).json({ error: err.message })
  }
}
