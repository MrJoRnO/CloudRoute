import os
import logging
import json
from flask import Flask, request, jsonify
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)

class JsonFormatter(logging.Formatter):
    def format(self, record):
        log_record = {
            "timestamp": self.formatTime(record),
            "level": record.levelname,
            "message": record.getMessage(),
            "module": record.module,
            "app": "url-shortener"
        }
        return json.dumps(log_record)

logger = logging.getLogger()
logHandler = logging.StreamHandler()
logHandler.setFormatter(JsonFormatter())
logger.addHandler(logHandler)
logger.setLevel(logging.INFO)

metrics = PrometheusMetrics(app)
metrics.info('app_info', 'URL Shortener application info', version='1.0.0')

DB_PASSWORD = os.getenv('DB_PASSWORD', 'default_password')

@app.route('/shorten', methods=['POST'])
def shorten():
    data = request.get_json()
    url = data.get('url')
     
    logger.info(f"URL shorten request received for: {url}")
    
    return jsonify({
        "short_url": "http://short.ly/abc123", 
        "original_url": url
    }), 201

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)