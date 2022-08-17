import logging

from django.shortcuts import render

logger = logging.getLogger()


def hello(request):
    resource = request.GET.get("r", "World")
    logger.debug(request.headers.get("User-Agent", None))
    logger.info("Send hello to %s", resource)
    return render(request, "index.html", {"name": resource})
