from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify(
        status="success",
        message="Salutare!",
        version="1.0.0"
    )

@app.route('/health')
def health_check():
    # Kubernetes va folosi această rută pentru a verifica dacă containerul e viu
    return jsonify(status="healthy"), 200

if __name__ == '__main__':
    # Rulăm pe 0.0.0.0 ca să poată fi accesat din afara containerului
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)