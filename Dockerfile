# Base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first (for layer caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all application files
COPY . .

# Initialize the database at build time
RUN python -c "import db; db.init_db()"

# Set default port environment variable (Render will override this)
ENV PORT=5000

# Start command using shell form so $PORT expands
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT --workers 2 app:app"]