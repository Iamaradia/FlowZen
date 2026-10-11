import sqlite3
import json
from contextlib import closing
from datetime import datetime
from pathlib import Path


DATABASE_NAME = Path(__file__).resolve().parent.parent / "focus_data.db"

# Creates a database if it doesn't exist
def create_database():
    with closing(sqlite3.connect(DATABASE_NAME)) as connection:
        with connection:
            connection.execute("""
                CREATE TABLE IF NOT EXISTS sessions (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    started_at TEXT,
                    ended_at TEXT,
                    focus_seconds REAL,
                    session_seconds REAL,
                    distraction_seconds REAL
                )
            """)

            connection.execute("""
                CREATE TABLE IF NOT EXISTS activity_cache (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    activity_type TEXT NOT NULL,
                    name TEXT NOT NULL,
                    title TEXT NOT NULL,
                    goal TEXT NOT NULL,
                    classification TEXT NOT NULL,
                    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
                    UNIQUE(activity_type, name, title, goal)
                )
            """)


def _ensure_session_metadata(connection):
    columns = {row[1] for row in connection.execute("PRAGMA table_info(sessions)")}
    for name, declaration in {
        "title": "TEXT NOT NULL DEFAULT 'Focus session'",
        "events_json": "TEXT NOT NULL DEFAULT '[]'",
        "apps_json": "TEXT NOT NULL DEFAULT '[]'",
        "away_seconds": "REAL NOT NULL DEFAULT 0",
    }.items():
        if name not in columns:
            connection.execute(f"ALTER TABLE sessions ADD COLUMN {name} {declaration}")


def initialize_qml_database():
    create_database()
    with closing(sqlite3.connect(DATABASE_NAME)) as connection:
        with connection:
            _ensure_session_metadata(connection)


def save_session(
        started_at,
        focus_seconds,
        session_seconds,
        distraction_seconds,
        *,
        title="Focus session",
        events=None,
        apps=None,
        away_seconds=0,
):
    ended_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    with closing(sqlite3.connect(DATABASE_NAME)) as connection:
        with connection:
            _ensure_session_metadata(connection)
            connection.execute("""
                INSERT INTO sessions (
                    started_at,
                    ended_at,
                    focus_seconds,
                    session_seconds,
                    distraction_seconds,
                    title,
                    events_json,
                    apps_json,
                    away_seconds
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                started_at,
                ended_at,
                focus_seconds,
                session_seconds,
                distraction_seconds,
                title,
                json.dumps(events or []),
                json.dumps(apps or []),
                away_seconds,
            ))

def get_sessions():
    with closing(sqlite3.connect(DATABASE_NAME)) as connection:
        connection.row_factory = sqlite3.Row
        rows = connection.execute("SELECT * FROM sessions ORDER BY started_at DESC, id DESC").fetchall()
    sessions = []
    for row in rows:
        session = dict(row)
        for key in ("events", "apps"):
            try:
                session[key] = json.loads(session.pop(key + "_json"))
            except (ValueError, TypeError):
                session[key] = []
        sessions.append(session)
    return sessions



def create_activity_cache_table():
    connection = sqlite3.connect(DATABASE_NAME)
    cursor = connection.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS activity_cache (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            activity_type TEXT NOT NULL,
            name TEXT NOT NULL,
            title TEXT NOT NULL,
            goal TEXT NOT NULL,
            classification TEXT NOT NULL,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(activity_type, name, title, goal)
        )
    """)

    connection.commit()
    connection.close()


def normalize_text(text):
    if text is None:
        return ""

    return " ".join(text.lower().strip().split())


def update_activity_answer(activity_type, name, title, goal, classification):
    classification = classification.upper().strip()

    if classification not in ["D", "A", "S"]:
        raise ValueError("Classification must be D, A, or S")

    activity_type = normalize_text(activity_type)
    name = normalize_text(name)
    title = normalize_text(title)
    goal = normalize_text(goal)

    connection = sqlite3.connect(DATABASE_NAME)
    cursor = connection.cursor()

    cursor.execute("""
        INSERT INTO activity_cache (activity_type, name, title, goal, classification)
        VALUES (?, ?, ?, ?, ?)

        ON CONFLICT(activity_type, name, title, goal)
        DO UPDATE SET
            classification = excluded.classification,
            updated_at = CURRENT_TIMESTAMP
    """, (activity_type, name, title, goal, classification))

    connection.commit()
    connection.close()


def get_activity_answer(activity_type, name, title, goal):
    activity_type = normalize_text(activity_type)
    name = normalize_text(name)
    title = normalize_text(title)
    goal = normalize_text(goal)

    connection = sqlite3.connect(DATABASE_NAME)
    cursor = connection.cursor()

    cursor.execute("""
        SELECT classification
        FROM activity_cache
        WHERE activity_type = ? AND name = ? AND title = ? AND goal = ?""",
        (activity_type, name, title, goal))

    result = cursor.fetchone()

    connection.close()

    if result is None:
        return None

    return result[0]


def clear_activity_cache():
    connection = sqlite3.connect(DATABASE_NAME)
    cursor = connection.cursor()

    cursor.execute("DELETE FROM activity_cache")

    connection.commit()
    connection.close()
