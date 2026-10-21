import { useState, useEffect } from 'react'

const STORAGE_KEY = 'notes-app-data'
const THEME_KEY = 'notes-app-theme'

function loadNotes() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) return JSON.parse(raw)
  } catch {
    /* ignore */
  }
  return [
    {
      id: Date.now(),
      title: 'Welcome to your Notes',
      body: 'Click "New Note" to start writing. Your notes are saved automatically.',
      updatedAt: new Date().toISOString(),
    },
  ]
}

function loadTheme() {
  return localStorage.getItem(THEME_KEY) === 'dark'
}

export default function App() {
  const [notes, setNotes] = useState(loadNotes)
  const [activeId, setActiveId] = useState(() => {
    const initial = loadNotes()
    return initial[0]?.id ?? null
  })
  const [dark, setDark] = useState(loadTheme)

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(notes))
  }, [notes])

  useEffect(() => {
    document.body.classList.toggle('dark', dark)
    localStorage.setItem(THEME_KEY, dark ? 'dark' : 'light')
  }, [dark])

  const activeNote = notes.find((n) => n.id === activeId)

  const createNote = () => {
    const note = {
      id: Date.now(),
      title: 'Untitled note',
      body: '',
      updatedAt: new Date().toISOString(),
    }
    setNotes([note, ...notes])
    setActiveId(note.id)
  }

  const updateNote = (field, value) => {
    setNotes((prev) =>
      prev.map((n) =>
        n.id === activeId
          ? { ...n, [field]: value, updatedAt: new Date().toISOString() }
          : n,
      ),
    )
  }

  const deleteNote = () => {
    if (!activeNote) return
    const remaining = notes.filter((n) => n.id !== activeId)
    setNotes(remaining)
    setActiveId(remaining[0]?.id ?? null)
  }

  return (
    <div className="app">
      <header>
        <div className="header-row">
          <div>
            <h1>📝 My Notes</h1>
            <p>Capture ideas, thoughts, and to-dos.</p>
          </div>
          <button
            className="theme-toggle"
            onClick={() => setDark((d) => !d)}
            aria-label="Toggle dark mode"
          >
            {dark ? '☀️' : '🌙'}
          </button>
        </div>
      </header>

      <div className="layout">
        <aside className="sidebar">
          <button className="new-note-btn" onClick={createNote}>
            + New Note
          </button>
          <ul className="note-list">
            {notes.length === 0 && (
              <li style={{ color: '#999', cursor: 'default' }}>
                No notes yet
              </li>
            )}
            {notes.map((n) => (
              <li
                key={n.id}
                className={n.id === activeId ? 'active' : ''}
                onClick={() => setActiveId(n.id)}
              >
                <div className="title">{n.title || 'Untitled'}</div>
                <div className="preview">
                  {n.body || 'No additional text'}
                </div>
              </li>
            ))}
          </ul>
        </aside>

        <main className="editor">
          {activeNote ? (
            <>
              <input
                type="text"
                value={activeNote.title}
                placeholder="Note title"
                onChange={(e) => updateNote('title', e.target.value)}
              />
              <textarea
                value={activeNote.body}
                placeholder="Start writing..."
                onChange={(e) => updateNote('body', e.target.value)}
              />
              <div className="actions">
                <span className="meta">
                  Last updated:{' '}
                  {new Date(activeNote.updatedAt).toLocaleString()}
                </span>
                <button onClick={deleteNote}>Delete</button>
              </div>
            </>
          ) : (
            <div className="empty">Select or create a note to begin.</div>
          )}
        </main>
      </div>
    </div>
  )
}
