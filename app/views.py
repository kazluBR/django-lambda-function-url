from django.shortcuts import render

def hello(request):
    resource = request.GET.get("r", None)
    return render(request, "index.html", {"name": resource or "World"})
