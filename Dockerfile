# שלב 1: בנייה (Build Stage)
FROM python:3.9-alpine AS builder
RUN apk add --no-cache gcc musl-dev libffi-dev
WORKDIR /app

# יצירת תיקיית התלויות
RUN mkdir -p /app/deps

# התקנה מראש של הגרסאות המאובטחות לתוך תיקיית היעד
RUN pip install --target=/app/deps --no-cache-dir \
    wheel==0.46.2 \
    jaraco.context==6.1.0 \
    setuptools==70.0.0

COPY app/requirements.txt .

RUN pip install --target=/app/deps --upgrade -r requirements.txt

# שלב 2: הרצה (Runtime Stage)
FROM python:3.9-alpine
WORKDIR /app
RUN apk upgrade --no-cache
RUN addgroup -S appuser && adduser -S appuser -G appuser

COPY --from=builder /app/deps /app/deps
COPY app/ .

ENV PYTHONPATH="/app/deps"
USER appuser

EXPOSE 5000
CMD ["python", "main.py"]