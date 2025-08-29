FROM python:3.12-slim AS base
ENV PYTHONDONTWRITEBYTECODE=1 \
PYTHONUNBUFFERED=1 \
PIP_NO_CACHE_DIR=1


WORKDIR /app


RUN apt-get update -y && apt-get install -y --no-install-recommends \
curl ca-certificates && \
rm -rf /var/lib/apt/lists/*


COPY requirements.txt .
RUN python -m pip install --upgrade pip && pip install -r requirements.txt


COPY . .


RUN useradd -m app && chown -R app:app /app
USER app


EXPOSE 8000
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8000", "-w", "2", "--threads", "4", "--access-logfile", "-"]