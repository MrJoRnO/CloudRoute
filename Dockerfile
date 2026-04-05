FROM python:3.9-slim AS builder
WORKDIR /app
COPY app/requirements.txt .

RUN pip install --target=/app/deps -r requirements.txt

FROM python:3.9-slim
WORKDIR /app

RUN apt-get update && apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r appuser && useradd -r -g appuser appuser

COPY --from=builder /app/deps /app/deps
COPY app/ .

# הגדרת נתיבים והחלפת משתמש
ENV PYTHONPATH="/app/deps"
USER appuser

EXPOSE 5000
CMD ["python", "main.py"]