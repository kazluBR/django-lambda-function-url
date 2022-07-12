import environ
import os
from .settings import *

env = environ.Env()
env.read_env(str(BASE_DIR / ".env.prod"))

REGION = os.environ.get("REGION", "us-east-1")

DEBUG = os.environ.get("DEBUG", "0") == "1"

SECRET_KEY = env("DJANGO_SECRET_KEY")

ALLOWED_HOSTS = [os.environ.get("DJANGO_ALLOWED_HOST", f".lambda-url.{REGION}.on.aws")]

MIDDLEWARE += ["whitenoise.middleware.WhiteNoiseMiddleware"]

STATIC_ROOT = BASE_DIR / "staticfiles"
WHITENOISE_STATIC_PREFIX = "/static/"
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"

INSTALLED_APPS += ["django_s3_sqlite"]

DATABASES = {
    "default": {
        "ENGINE": "django_s3_sqlite",
        "NAME": f'{env("SQLITE_DB_NAME")}.db',
        "BUCKET": env("AWS_S3_BUCKET_DB"),
        "AWS_S3_ACCESS_KEY": env("AWS_S3_ACCESS_KEY"),
        "AWS_S3_ACCESS_SECRET": env("AWS_S3_ACCESS_SECRET"),
        "TEST": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": BASE_DIR / "db.sqlite3",
        },
    }
}

LOGGING["root"]["level"] = "DEBUG" if DEBUG else "INFO"
