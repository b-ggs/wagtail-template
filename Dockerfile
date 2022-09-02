FROM python:3.9.13

# Set up user
RUN useradd --create-home wagtail_template

# Set up project directory
ENV APP_DIR=/app
RUN mkdir -p "$APP_DIR" && chown -R wagtail_template "$APP_DIR"

# Set up virtualenv
ENV VIRTUAL_ENV=/venv
ENV PATH=$VIRTUAL_ENV/bin:$PATH
RUN mkdir -p "$VIRTUAL_ENV" && chown -R wagtail_template:wagtail_template "$VIRTUAL_ENV"

# Install poetry 1.1
ENV GET_POETRY_IGNORE_DEPRECATION=1
ENV POETRY_VERSION=1.1.15
ENV POETRY_HOME=/opt/poetry
ENV PATH=$POETRY_HOME/bin:$PATH
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python - \
    && chown -R wagtail_template:wagtail_template "$POETRY_HOME"

# Switch to unprivileged user
USER wagtail_template

# Switch to project directory
WORKDIR $APP_DIR

# Set environment variables
# 1. Force Python stdout and stderr streams to be unbuffered.
# 2. Set PORT variable that is used by Gunicorn. This should match "EXPOSE"
#    command.
ENV PYTHONUNBUFFERED=1 \
    PORT=8000

# Install project dependencies
RUN python -m venv $VIRTUAL_ENV
COPY --chown=wagtail_template pyproject.toml poetry.lock ./
RUN pip install --upgrade pip && poetry install --no-root

# Port used by this container to serve HTTP.
EXPOSE 8000

# Copy the source code of the project into the container.
COPY --chown=wagtail_template:wagtail_template . .

# Collect static files.
RUN python manage.py collectstatic --noinput --clear

CMD ["gunicorn", "wagtail_template.wsgi:application"]
