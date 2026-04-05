FROM python:3.9-alpine AS builder
RUN apk add --no-cache gcc musl-dev libffi-dev
WORKDIR /app
COPY app/requirements.txt .

# עדכון כלי הבנייה לגרסאות מאובטחות לפי הדו"ח של Trivy
RUN pip install --no-cache-dir --upgrade pip setuptools wheel==0.46.2 jaraco.context==6.1.0

RUN pip install --target=/app/deps -r requirements.txt

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