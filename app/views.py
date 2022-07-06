import logging, json

from django.shortcuts import render

logger = logging.getLogger()

def hello(request):
    resource = request.GET.get("r", "World")
    logger.debug(json.dumps(request.COOKIES))
    logger.info('Send hello to %s', resource)
    return render(request, "index.html", { "name": resource })
