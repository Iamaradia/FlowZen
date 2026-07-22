import sqlite3
from contextlib import closing
from datetime import datetime
from pathlib import Path


DATABASE_NAME = Path(__file__).resolve().parent / "focus_data.db"

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


def save_session(
        started_at,
        focus_seconds,
        session_seconds,
        distraction_seconds
):
    ended_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    with closing(sqlite3.connect(DATABASE_NAME)) as connection:
        with connection:
            connection.execute("""
                INSERT INTO sessions (
                    started_at,
                    ended_at,
                    focus_seconds,
                    session_seconds,
                    distraction_seconds
                )
                VALUES (?, ?, ?, ?, ?)
            """, (
                started_at,
                ended_at,
                focus_seconds,
                session_seconds,
                distraction_seconds
            ))

    print("Session saved successfully")
