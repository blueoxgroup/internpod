const { requireAdmin } = require('../_lib/auth')
const { getPool } = require('../_lib/db')

module.exports = async function handler(req, res) {
  try {
    const db = getPool()
    await requireAdmin(req, db)

    if (req.method === 'GET') {
      const { rows } = await db.query(
        `SELECT i.*, ps.startup_name, ps.confirmed
         FROM public.interns i
         LEFT JOIN public.pod_selections ps ON ps.intern_id = i.id
         ORDER BY
           CASE i.status WHEN 'pending' THEN 0 WHEN 'approved' THEN 1 ELSE 2 END,
           i.created_at DESC`
      )
      return res.status(200).json(rows)
    }

    if (req.method === 'PUT') {
      const { id } = req.query
      const { status } = req.body
      if (!id) return res.status(400).json({ error: 'id required' })
      if (!['approved', 'rejected', 'pending'].includes(status)) {
        return res.status(400).json({ error: 'status must be approved, rejected, or pending' })
      }
      const { rows } = await db.query(
        `UPDATE public.interns SET status = $1 WHERE id = $2 RETURNING *`,
        [status, id]
      )
      if (!rows[0]) return res.status(404).json({ error: 'Intern not found' })
      return res.status(200).json(rows[0])
    }

    return res.status(405).json({ error: 'Method not allowed' })
  } catch (err) {
    return res.status(err.status || 500).json({ error: err.message })
  }
}
