const { requireAuth } = require('../_lib/auth')
const { getPool } = require('../_lib/db')

module.exports = async function handler(req, res) {
  try {
    const { userId } = await requireAuth(req)
    const db = getPool()

    const { rows: profileRows } = await db.query(
      'SELECT role FROM public.profiles WHERE id = $1',
      [userId]
    )
    const role = profileRows[0]?.role

    if (req.method === 'GET') {
      let rows

      if (req.query.all === 'true') {
        // Return minimal data for all selections — used by hiring grid to show taken status
        const result = await db.query(
          'SELECT id, intern_id, startup_id, confirmed FROM public.pod_selections'
        )
        return res.status(200).json(result.rows)
      }

      if (role === 'admin') {
        // Admin sees all selections with intern details
        const result = await db.query(
          `SELECT ps.*, i.name as intern_name, i.main_skill, i.email as intern_email
           FROM public.pod_selections ps
           JOIN public.interns i ON ps.intern_id = i.id
           ORDER BY ps.created_at DESC`
        )
        rows = result.rows
      } else if (role === 'startup') {
        // Startup sees only their own selections
        const result = await db.query(
          `SELECT ps.*, i.name as intern_name, i.main_skill, i.location,
                  i.github, i.portfolio, i.linkedin, i.skills_detail,
                  i.availability, i.english_level, i.timezones
           FROM public.pod_selections ps
           JOIN public.interns i ON ps.intern_id = i.id
           WHERE ps.startup_id = $1
           ORDER BY ps.created_at DESC`,
          [userId]
        )
        rows = result.rows
      } else {
        return res.status(403).json({ error: 'Only startups and admins can view selections' })
      }

      return res.status(200).json(rows)
    }

    if (req.method === 'POST') {
      if (role !== 'startup') {
        return res.status(403).json({ error: 'Only startups can select interns' })
      }

      const { intern_id } = req.body
      if (!intern_id) return res.status(400).json({ error: 'intern_id is required' })

      // Get startup info
      const { rows: startup } = await db.query(
        'SELECT company_name, email FROM public.startup_profiles WHERE user_id = $1',
        [userId]
      )

      const { rows } = await db.query(
        `INSERT INTO public.pod_selections (startup_id, startup_email, startup_name, intern_id)
         VALUES ($1, $2, $3, $4)
         RETURNING *`,
        [userId, startup[0]?.email, startup[0]?.company_name, intern_id]
      )
      return res.status(201).json(rows[0])
    }

    return res.status(405).json({ error: 'Method not allowed' })
  } catch (err) {
    if (err.code === '23505') {
      return res.status(409).json({ error: 'This intern is already in a pod' })
    }
    return res.status(err.status || 500).json({ error: err.message })
  }
}
