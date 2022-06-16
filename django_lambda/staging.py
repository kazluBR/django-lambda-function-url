import environ
from .settings import *

env = environ.Env()
env.read_env(str(BASE_DIR / ".env.staging"))

DEBUG = False

SECRET_KEY = env("DJANGO_SECRET_KEY")

ALLOWED_HOSTS = env.list("DJANGO_ALLOWED_HOSTS")

MIDDLEWARE += ["whitenoise.middleware.WhiteNoiseMiddleware"]

STATIC_URL = "/static/"
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
    }
}
