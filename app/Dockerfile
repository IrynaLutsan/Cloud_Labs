FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1
WORKDIR /app

RUN useradd -m -u 1000 appuser

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]