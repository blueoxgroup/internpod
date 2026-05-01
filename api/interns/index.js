const { requireAuth } = require('../_lib/auth')
const { getPool } = require('../_lib/db')

module.exports = async function handler(req, res) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' })
  }

  try {
    await requireAuth(req)
    const db = getPool()

    const { rows } = await db.query(
      `SELECT * FROM public.interns ORDER BY created_at DESC`
    )

    return res.status(200).json(rows)
  } catch (err) {
    return res.status(err.status || 500).json({ error: err.message })
  }
}
