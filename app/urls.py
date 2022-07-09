from django.urls import path
from .views import hello

app_name = "app"

urlpatterns = [
    path("", hello, name="hello"),
]
