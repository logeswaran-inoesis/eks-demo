# -------------------------
# Stage 1: Build stage
# -------------------------
FROM python:3.11-slim AS build

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv $VENV_PATH
ENV PATH="$VENV_PATH/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# -------------------------
# Stage 2: Production stage
# -------------------------
FROM python:3.11-slim AS final

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv
ENV PATH="$VENV_PATH/bin:$PATH"

# Create non-root user
RUN useradd --create-home appuser
WORKDIR /app

# Copy virtual environment from build stage
COPY --from=build /opt/venv /opt/venv

# Copy project files from build stage
COPY --from=build /app /app

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port for Django
EXPOSE 8000 
# Run Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
