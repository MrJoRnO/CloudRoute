import pytest
from main import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_health(client):
    """בדיקה שה-Endpoint של ה-Health מחזיר 200"""
    rv = client.get('/health')
    assert rv.status_code == 200
    assert rv.get_json() == {"status": "healthy"}

def test_shorten_endpoint(client):
    """בדיקה שה-Endpoint של הקיצור עובד"""
    rv = client.post('/shorten', json={"url": "https://google.com"})
    assert rv.status_code == 201
    assert "short_url" in rv.get_json()