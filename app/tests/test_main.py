from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_health():
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.json() == {"status": "ok"}


def test_index_without_database(monkeypatch):
    monkeypatch.delenv("DB_HOST", raising=False)
    resp = client.get("/")
    assert resp.status_code == 200
    assert resp.json()["database"] == "not configured"


def test_visits_without_database(monkeypatch):
    monkeypatch.delenv("DB_HOST", raising=False)
    resp = client.get("/visits")
    assert resp.status_code == 503
