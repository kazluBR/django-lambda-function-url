# django-lambda-function-url

## A Django Project running on AWS Lambda Function Url

## Initial steps (Windows)

- Create virtual env: `python -m venv env`
- Activate virtual: `./env/Scripts/Activate.ps1`
- Upgrade pip: `python -m pip install --upgrade pip`
- Install django package: `pip install django`
- Create django project: `django-admin startproject django_lambda`
- Create requirements file: `pip freeze > requirements.txt`
- Create app on django project (inside django_lambda folder): `python manage.py startapp app`
