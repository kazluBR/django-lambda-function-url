import environ
import os
import sys
from .settings import *

__import__("pysqlite3")
import sys

sys.modules["sqlite3"] = sys.modules.pop("pysqlite3")

env = environ.Env()
env.read_env(str(BASE_DIR / ".env.staging"))

REGION = os.environ.get("REGION", "us-east-1")

DEBUG = os.environ.get("DEBUG", "0") == "1"

LOCAL = False

SECRET_KEY = env("DJANGO_SECRET_KEY")

ALLOWED_HOSTS = [os.environ.get("DJANGO_ALLOWED_HOST", f".lambda-url.{REGION}.on.aws")]

MIDDLEWARE += ["whitenoise.middleware.WhiteNoiseMiddleware"]

STATIC_ROOT = BASE_DIR / "staticfiles"
WHITENOISE_STATIC_PREFIX = "/static/"
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"

MEDIA_URL = "/tmp/media/"  # just for don't throw an error, media will not persist
MEDIA_ROOT = (
    BASE_DIR / "/tmp/media"
)  # just for don't throw an error, media will not persist

INSTALLED_APPS += ["django_s3_sqlite"]

DATABASES = {
    "default": {
        "ENGINE": "django_s3_sqlite",
        "NAME": env("SQLITE_DB_NAME", default="database.db"),
        "BUCKET": env("AWS_S3_BUCKET_DB"),
        "AWS_S3_ACCESS_KEY": env("AWS_S3_ACCESS_KEY"),
        "AWS_S3_ACCESS_SECRET": env("AWS_S3_ACCESS_SECRET"),
        "TEST": {
            "NAME": BASE_DIR / "db.sqlite3",
        },
    }
}

if "test" in sys.argv:
    DATABASES["default"] = {
        "ENGINE": "django.db.backends.sqlite3",
    }

LOGGING["root"]["level"] = "DEBUG" if DEBUG else "INFO"
