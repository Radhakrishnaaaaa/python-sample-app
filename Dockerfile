FROM ubuntu:latest

WORKDIR /app

COPY requirements.txt /app
COPY devops /app

RUN apt-get update
RUN apt-get install -y python3 
RUN apt install python3-pip -y
RUN apt install python3.12-venv -y
RUN python3 -m venv /app/venv
RUN . /app/venv/bin/activate
RUN /app/venv/bin/pip install -r requirements.txt
RUN cd devops

ENTRYPOINT ["/app/venv/bin/python3"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]


-------------------------------------------------------

# Stage 1: Build Stage
FROM ubuntu:latest AS builder

# Set the working directory
WORKDIR /app

# Copy application files and requirements
COPY requirements.txt /app
COPY devops /app

# Install Python and pip for the build process
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3.12-venv && \
    apt-get clean

# Create a virtual environment and install dependencies
RUN python3 -m venv /app/venv && \
    /app/venv/bin/pip install --upgrade pip && \
    /app/venv/bin/pip install -r requirements.txt

# Stage 2: Runtime Stage
FROM ubuntu:latest

# Set the working directory
WORKDIR /app

# Install Python runtime
RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get clean

# Copy the application files
COPY devops /app

# Copy the pre-built virtual environment from the builder stage
COPY --from=builder /app/venv /app/venv

# Activate the virtual environment and start the application
ENTRYPOINT ["/app/venv/bin/python3"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]
