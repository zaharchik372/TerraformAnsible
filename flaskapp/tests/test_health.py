import json
from app import app


def test_healthz():
    with app.test_client() as c:
        resp = c.get('/healthz')
        assert resp.status_code == 200
        data = json.loads(resp.data)
        assert data['status'] == 'ok