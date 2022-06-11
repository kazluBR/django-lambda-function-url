import environ
from .settings import *

env = environ.Env()
env.read_env(str(BASE_DIR / ".env.production"))

DEBUG = False

SECRET_KEY = env("DJANGO_SECRET_KEY")

ALLOWED_HOSTS = env.list("DJANGO_ALLOWED_HOSTS")

ADMIN_URL = env("DJANGO_ADMIN_URL")

INSTALLED_APPS += ["storages"]

AWS_S3_CUSTOM_DOMAIN = "%s.s3.amazonaws.com" % env("AWS_STORAGE_BUCKET_NAME")
AWS_S3_OBJECT_PARAMETERS = {
    "CacheControl": "max-age=86400",
}
AWS_LOCATION = "static"

STATIC_ROOT = str(BASE_DIR / "staticfiles")
STATICFILES_DIRS = [str(BASE_DIR / "static")]
STATIC_URL = "https://%s/%s/" % (AWS_S3_CUSTOM_DOMAIN, AWS_LOCATION)

STATICFILES_STORAGE = "storages.backends.s3boto3.S3Boto3Storage"

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": env("DB_NAME"),
        "USER": env("DB_USER"),
        "PASSWORD": env("DB_PASSWORD"),
        "HOST": env("DB_HOST"),
        "PORT": "3306",
    }
}
