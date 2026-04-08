FROM python:3.10-slim

WORKDIR /app

# Install system dependencies required by dlib and face-recognition
RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py ml_core.py shortlisting_pipeline.py album_processor.py ./
COPY templates/ ./templates/

# Create required directories
RUN mkdir -p album_images user_uploads testing_data databases

# Expose port (Render will override this, but it's good practice)
EXPOSE 5001

# Run the application using the PORT environment variable provided by Render
CMD ["python", "app.py"]
