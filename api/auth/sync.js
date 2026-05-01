const { requireAuth } = require('../_lib/auth')
const { getPool } = require('../_lib/db')

module.exports = async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' })
  }

  try {
    const { userId } = await requireAuth(req)
    const { role, email } = req.body

    if (!role || !['intern', 'startup', 'admin'].includes(role)) {
      return res.status(400).json({ error: 'Valid role required (intern, startup, admin)' })
    }

    const db = getPool()

    // Create profile if it doesn't exist
    await db.query(
      `INSERT INTO public.profiles (id, role, email)
       VALUES ($1, $2, $3)
       ON CONFLICT (id) DO NOTHING`,
      [userId, role, email]
    )

    let internId = null

    if (role === 'intern' && email) {
      // Try to claim a seeded intern row by email
      const { rowCount, rows } = await db.query(
        `UPDATE public.interns
         SET user_id = $1
         WHERE email = $2 AND user_id IS NULL
         RETURNING id`,
        [userId, email]
      )

      if (rowCount > 0) {
        internId = rows[0].id
      } else {
        // Check if they already have a row
        const { rows: existing } = await db.query(
          'SELECT id FROM public.interns WHERE user_id = $1',
          [userId]
        )

        if (existing.length === 0) {
          // First time — create a fresh empty intern row
          const { rows: created } = await db.query(
            `INSERT INTO public.interns (user_id, email)
             VALUES ($1, $2)
             ON CONFLICT (user_id) DO NOTHING
             RETURNING id`,
            [userId, email]
          )
          if (created[0]) internId = created[0].id
        } else {
          internId = existing[0].id
        }
      }
    }

    // Fetch final profile role
    const { rows: profile } = await db.query(
      'SELECT role FROM public.profiles WHERE id = $1',
      [userId]
    )

    return res.status(200).json({
      ok: true,
      role: profile[0]?.role || role,
      internId,
    })
  } catch (err) {
    return res.status(err.status || 500).json({ error: err.message })
  }
}
