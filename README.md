# django-lambda-function-url

## A Django Project running on AWS Lambda Function Url

## Initial steps (Windows)

- Create virtual env: `python -m venv env`
- Activate virtual: `./env/Scripts/Activate.ps1`
- Upgrade pip: `python -m pip install --upgrade pip`
- Install django package: `pip install django`
- Create django project: `django-admin startproject django_lambda .`
- Create requirements file: `pip freeze > requirements.txt`
- Create app on django project: `python .\django_lambda\manage.py startapp app`
- Apply database migrations: `python .\django_lambda\manage.py migrate`
- Create superuser and fill the steps: `python .\django_lambda\manage.py createsuperuser`
- Set environment: `$Env:DJANGO_SETTINGS_MODULE="django_lambda.local"`
- Run server: `python .\django_lambda\manage.py runserver`
- Access the website at link: http://localhost:8000/
