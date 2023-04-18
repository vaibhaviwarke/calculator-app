FROM python:3.7

# Copy source file and python requirements and set the working directory to /app
COPY . /app
WORKDIR /app

HEALTHCHECK NONE

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt --no-cache-dir

# Set image's main command and run the command within the container
ENTRYPOINT ["python"]
CMD ["app.py"]