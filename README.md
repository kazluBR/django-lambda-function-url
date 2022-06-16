# django-lambda-function-url

## A Django Project running on AWS Lambda Function Url

## Running Local

- Create virtual env: `python -m venv env`
- Activate virtual: `./env/Scripts/Activate.ps1`
- Upgrade pip: `python -m pip install --upgrade pip`
- Install packages: `pip install -r requirements.txt`
- Apply database migrations: `python .\django_lambda\manage.py migrate`
- Create superuser and fill the fields: `python .\django_lambda\manage.py createsuperuser`
- Run server: `python .\django_lambda\manage.py runserver`
- Access the website at link: http://localhost:8000/

## Running on AWS

- Create bucket on AWS S3 to store sqlite db
- Create IAM User with AmazonS3FullAccess and Access Key
- Create .env.<staging | prod> file in the root directory and configure the following variables:

```dotenv
STAGE=
DJANGO_SECRET_KEY=
DJANGO_ALLOWED_HOSTS=
DJANGO_SUPERUSER_USERNAME=
DJANGO_SUPERUSER_PASSWORD=
DJANGO_SUPERUSER_EMAIL=
SQLITE_DB_NAME=
AWS_S3_BUCKET_DB=
AWS_S3_ACCESS_KEY=
AWS_S3_ACCESS_SECRET=
```

- Install packages: `npm install`
- Put AWS credentials on your PC
- Deploy on AWS: `npx sls deploy -s <staging | prod>`
