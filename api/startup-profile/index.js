const { requireAuth } = require('../_lib/auth')
const { getPool } = require('../_lib/db')

module.exports = async function handler(req, res) {
  try {
    const { userId } = await requireAuth(req)
    const db = getPool()

    if (req.method === 'GET') {
      const { rows } = await db.query(
        'SELECT * FROM public.startup_profiles WHERE user_id = $1',
        [userId]
      )
      return res.status(200).json(rows[0] || null)
    }

    if (req.method === 'POST') {
      const {
        company_name, website, description,
        industry, team_size, location, email, roles_needed,
      } = req.body

      if (!company_name) {
        return res.status(400).json({ error: 'company_name is required' })
      }

      const { rows } = await db.query(
        `INSERT INTO public.startup_profiles
          (user_id, company_name, website, description, industry, team_size, location, email, roles_needed)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
         RETURNING *`,
        [userId, company_name, website, description, industry, team_size, location, email, roles_needed]
      )
      return res.status(201).json(rows[0])
    }

    if (req.method === 'PUT') {
      const {
        company_name, website, description,
        industry, team_size, location, email, roles_needed,
      } = req.body

      const { rows } = await db.query(
        `UPDATE public.startup_profiles SET
          company_name = COALESCE($1, company_name),
          website = COALESCE($2, website),
          description = COALESCE($3, description),
          industry = COALESCE($4, industry),
          team_size = COALESCE($5, team_size),
          location = COALESCE($6, location),
          email = COALESCE($7, email),
          roles_needed = COALESCE($8, roles_needed)
         WHERE user_id = $9
         RETURNING *`,
        [company_name, website, description, industry, team_size, location, email, roles_needed, userId]
      )
      if (!rows[0]) return res.status(404).json({ error: 'Startup profile not found' })
      return res.status(200).json(rows[0])
    }

    return res.status(405).json({ error: 'Method not allowed' })
  } catch (err) {
    return res.status(err.status || 500).json({ error: err.message })
  }
}
