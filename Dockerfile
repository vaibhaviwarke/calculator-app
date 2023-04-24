FROM python:3.7
# RUN adduser --system --group --no-create-home non-root-user
# USER non-root-user

# Copy source file and python requirements and set the working directory to /app
COPY . /app
WORKDIR /app

HEALTHCHECK NONE

# Install any needed packages specified in requirements.txt
RUN pip install --disable-pip-version-check --no-cache-dir -r requirements.txt --user

# Set image's main command and run the command within the container
ENTRYPOINT ["python"]
CMD ["app.py"]