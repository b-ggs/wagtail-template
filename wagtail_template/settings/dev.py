from .base import *  # noqa

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "django-insecure-nvg5arlsvczsdk5pzu-=f2qpst%ze8#jyuhfmldp7--j#ao5)j"  # pragma: allowlist secret  # nosec

# SECURITY WARNING: define the correct hosts in production!
ALLOWED_HOSTS = ["*"]

EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"

INSTALLED_APPS += ["wagtail.contrib.styleguide"]  # noqa
