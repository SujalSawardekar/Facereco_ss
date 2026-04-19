FROM python:3.10-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Using explicitly bookworm and adding --fix-missing to handle mirror sync issues
RUN apt-get update -y --fix-missing && \
    apt-get install -y --no-install-recommends \
    cmake \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create required directories
RUN mkdir -p album_images user_uploads testing_data databases

# Expose port
EXPOSE 5001

# Using Gunicorn for production-ready serving on Render
CMD ["gunicorn", "--bind", "0.0.0.0:5001", "app:app", "--timeout", "120"]
