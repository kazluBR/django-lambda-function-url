# Fix ImproperlyConfigured: SQLite 3.9.0 or later is required (found 3.7.17)
__import__("pysqlite3")
import sys

sys.modules["sqlite3"] = sys.modules.pop("pysqlite3")

import environ
from .settings import *

env = environ.Env()
env.read_env(str(BASE_DIR / ".env.staging"))

DEBUG = False

SECRET_KEY = env("DJANGO_SECRET_KEY")

ALLOWED_HOSTS = env.list("DJANGO_ALLOWED_HOSTS")
