"""Small FastAPI service used to demonstrate the ECS Fargate CI/CD pipeline.

The database is optional: when DB_HOST is not set the service still runs and
reports the database as "not configured".
"""

import os

from fastapi import FastAPI, HTTPException

app = FastAPI(title="fargate-cicd-demo")

APP_ENV = os.getenv("APP_ENV", "local")
APP_VERSION = os.getenv("APP_VERSION", "dev")


def _connect():
    """Open a Postgres connection, or return None when no database is configured."""
    if not os.getenv("DB_HOST"):
        return None
    import psycopg  # imported lazily so the app runs without a database

    return psycopg.connect(
        host=os.environ["DB_HOST"],
        dbname=os.getenv("DB_NAME", "appdb"),
        user=os.getenv("DB_USER", "appadmin"),
        password=os.getenv("DB_PASSWORD", ""),
        connect_timeout=3,
        sslmode="require",
    )


def _database_status() -> str:
    try:
        conn = _connect()
    except Exception:
        return "error"
    if conn is None:
        return "not configured"
    with conn:
        conn.execute("SELECT 1")
    return "connected"


@app.get("/health")
def health():
    """Liveness check used by the ALB target group."""
    return {"status": "ok"}


@app.get("/")
def index():
    return {
        "service": "fargate-cicd-demo",
        "environment": APP_ENV,
        "version": APP_VERSION,
        "database": _database_status(),
        "deployed_by": "GitHub Actions (OIDC) -> ECR -> ECS Fargate",
    }


@app.get("/visits")
def visits():
    """Increment and return a visit counter stored in Postgres."""
    try:
        conn = _connect()
    except Exception as exc:
        raise HTTPException(status_code=503, detail="database unavailable") from exc
    if conn is None:
        raise HTTPException(status_code=503, detail="database not configured")
    with conn:
        conn.execute(
            "CREATE TABLE IF NOT EXISTS visits (id INT PRIMARY KEY, count BIGINT NOT NULL)"
        )
        conn.execute(
            "INSERT INTO visits (id, count) VALUES (1, 1) "
            "ON CONFLICT (id) DO UPDATE SET count = visits.count + 1"
        )
        count = conn.execute("SELECT count FROM visits WHERE id = 1").fetchone()[0]
    return {"visits": count, "version": APP_VERSION}
