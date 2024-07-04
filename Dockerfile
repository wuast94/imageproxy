FROM python:3.13.0b3 AS base

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

ARG UID=10001
RUN adduser \
  --disabled-password \
  --gecos "" \
  --home "/nonexistent" \
  --shell "/sbin/nologin" \
  --no-create-home \
  --uid "${UID}" \
  appuser

RUN --mount=type=bind,source=requirements.txt,target=requirements.txt \
  python -m pip install --no-cache-dir -r requirements.txt

USER appuser

COPY app.py .

EXPOSE 8000

HEALTHCHECK --interval=10s --timeout=10s --start-period=5s --retries=3 CMD curl -f http://localhost:8000/health | grep OK || exit 1

# Run the application.
CMD ["waitress-serve", "--host=0.0.0.0", "--port=8000", "app:app"]
