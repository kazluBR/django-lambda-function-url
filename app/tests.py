from django.test import TestCase, Client
from django.urls import reverse

class HelloTest(TestCase):
    def setUp(self):
        self.client = Client()

    def test_default(self):
        response = self.client.get(reverse("app:hello"))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.context["name"], "World")

    def test_resource(self):
        response = self.client.get(reverse("app:hello"), {"r": "test"})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.context["name"], "test")
