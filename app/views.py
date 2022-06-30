from django.shortcuts import render
from django.contrib.auth.decorators import login_required

@login_required
def hello(request):
    resource = request.GET.get("r", None)
    return render(request, "index.html", {"name": resource or "World"})
