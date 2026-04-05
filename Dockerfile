FROM python:3.9-alpine AS builder
RUN apk add --no-cache gcc musl-dev libffi-dev
WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip setuptools wheel

COPY app/requirements.txt .
RUN pip install --no-cache-dir --target=/app/deps -r requirements.txt

RUN rm -rf /app/deps/wheel* /app/deps/setuptools* /app/deps/pkg_resources*

FROM python:3.9-alpine
WORKDIR /app

RUN apk upgrade --no-cache && \
    addgroup -S appuser && adduser -S appuser -G appuser

COPY --from=builder /app/deps /usr/local/lib/python3.9/site-packages
COPY app/main.py .

USER appuser
EXPOSE 5000
CMD ["python", "main.py"]