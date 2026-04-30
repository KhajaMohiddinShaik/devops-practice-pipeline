# ---------- Builder ----------
FROM python:3.11-slim AS builder

WORKDIR /app

# avoid pip cache + faster installs
ENV PIP_NO_CACHE_DIR=1

COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt

# ---------- Final ----------
FROM python:3.11-slim

WORKDIR /app

# copy only installed deps
COPY --from=builder /install /usr/local

# copy app code
COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
