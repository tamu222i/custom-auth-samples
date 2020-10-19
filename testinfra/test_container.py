import requests

def test_root(host):
    response = requests.get("http://localhost:80")
    assert response.status_code == 200
    assert 'exment' in response.text

