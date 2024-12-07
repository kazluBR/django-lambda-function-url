import environ
import os
import sys
from .settings import *

env = environ.Env()
env.read_env(str(BASE_DIR / ".env.production"))

REGION = os.environ.get("REGION", "us-east-1")

DEBUG = os.environ.get("DEBUG", "0") == "1"

LOCAL = False

SECRET_KEY = env("DJANGO_SECRET_KEY")

ALLOWED_HOSTS = [os.environ.get("DJANGO_ALLOWED_HOST", f".lambda-url.{REGION}.on.aws")]

INSTALLED_APPS += ["storages"]

AWS_ACCESS_KEY_ID = env("AWS_S3_ACCESS_KEY")
AWS_SECRET_ACCESS_KEY = env("AWS_S3_ACCESS_SECRET")
AWS_STORAGE_BUCKET_NAME = env("AWS_S3_BUCKET_STORAGE")
AWS_DEFAULT_REGION = REGION

AWS_S3_CUSTOM_DOMAIN = "%s.s3.amazonaws.com" % AWS_STORAGE_BUCKET_NAME
AWS_DEFAULT_ACL = "public-read"
AWS_S3_OBJECT_PARAMETERS = {
    "CacheControl": "max-age=86400",
}

AWS_LOCATION = "static"
STATICFILES_STORAGE = "storages.backends.s3boto3.S3Boto3Storage"
STATIC_URL = "https://%s/%s/" % (AWS_S3_CUSTOM_DOMAIN, AWS_LOCATION)

PUBLIC_MEDIA_LOCATION = "media"
DEFAULT_FILE_STORAGE = "django_lambda.utils.PublicMediaStorage"
MEDIA_URL = "https://%s/%s/" % (AWS_S3_CUSTOM_DOMAIN, PUBLIC_MEDIA_LOCATION)

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "HOST": env("RDS_MYSQL_DB_HOST"),
        "NAME": env("RDS_MYSQL_DB_NAME"),
        "USER": env("RDS_MYSQL_DB_USER"),
        "PASSWORD": env("RDS_MYSQL_DB_PASSWORD"),
        "PORT": env("DB_PORT", default="3306"),
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
