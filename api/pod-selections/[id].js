const { requireAuth } = require('../_lib/auth')
const { getPool } = require('../_lib/db')

module.exports = async function handler(req, res) {
  const { id } = req.query

  try {
    const { userId } = await requireAuth(req)
    const db = getPool()

    const { rows: profileRows } = await db.query(
      'SELECT role FROM public.profiles WHERE id = $1',
      [userId]
    )
    const role = profileRows[0]?.role

    if (req.method === 'PUT') {
      // Confirm a selection — startup only, must own it
      const { rows: selection } = await db.query(
        'SELECT startup_id FROM public.pod_selections WHERE id = $1',
        [id]
      )
      if (!selection[0]) return res.status(404).json({ error: 'Selection not found' })
      if (selection[0].startup_id !== userId && role !== 'admin') {
        return res.status(403).json({ error: 'Forbidden' })
      }

      const { confirmed } = req.body
      const { rows } = await db.query(
        `UPDATE public.pod_selections SET confirmed = $1 WHERE id = $2 RETURNING *`,
        [confirmed, id]
      )
      return res.status(200).json(rows[0])
    }

    if (req.method === 'DELETE') {
      // Deselect — startup only, must own it, and not confirmed
      const { rows: selection } = await db.query(
        'SELECT startup_id, confirmed FROM public.pod_selections WHERE id = $1',
        [id]
      )
      if (!selection[0]) return res.status(404).json({ error: 'Selection not found' })
      if (selection[0].startup_id !== userId && role !== 'admin') {
        return res.status(403).json({ error: 'Forbidden' })
      }
      if (selection[0].confirmed && role !== 'admin') {
        return res.status(400).json({ error: 'Cannot deselect a confirmed intern' })
      }

      await db.query('DELETE FROM public.pod_selections WHERE id = $1', [id])
      return res.status(200).json({ ok: true })
    }

    return res.status(405).json({ error: 'Method not allowed' })
  } catch (err) {
    return res.status(err.status || 500).json({ error: err.message })
  }
}
