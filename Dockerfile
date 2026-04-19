FROM python:3.10-slim

WORKDIR /app

# Install system dependencies required by dlib and face-recognition
# We combine update, install, and cleanup into one layer to save space
RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create required directories
RUN mkdir -p album_images user_uploads testing_data databases

# Expose port (Render will override this via the PORT env var)
EXPOSE 5001

# Using Gunicorn for production-ready serving on Render
# WEB_CONCURRENCY=1 is recommended for Free Tier to avoid OOM
CMD ["gunicorn", "--bind", "0.0.0.0:5001", "app:app", "--timeout", "120"]
