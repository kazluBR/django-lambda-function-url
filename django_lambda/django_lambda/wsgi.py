"""
WSGI config for django_lambda project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.0/howto/deployment/wsgi/
"""

import os
import serverless_wsgi

from django.core.wsgi import get_wsgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "django_lambda.local")

application = get_wsgi_application()


def handler(event, context):
    return serverless_wsgi.handle_request(application, event, context)
