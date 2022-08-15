# django-lambda-function-url

## A Django Project running on AWS Lambda Function Url

## Requirements

- Python 3.8
- Node 14.x
- Docker
- Terraform
- AWS Account

## Running Locally

- Create virtual env: `python -m venv env`
- Activate virtual: `./env/Scripts/Activate.ps1`
- Upgrade pip: `python -m pip install --upgrade pip`
- Install packages: `pip install -r requirements.txt`
- Apply database migrations: `python manage.py migrate`
- Create superuser and fill the fields: `python manage.py createsuperuser`
- Run server: `python manage.py runserver`
- Access the website at link: http://localhost:8000/

## Running on AWS (Staging)

\*_Don't support upload of media files_

\*_Concurrent writes will often be lost and not show up in concurrent readers. This is because the database is transferred between S3 storage and the Lambda instance for each request_

- Put AWS credentials on your PC
- Go to infra staging resources: `cd infra/staging`
- Initialize terraform: `terraform init`
- Create all resources: `terraform apply`
- Create `.env.staging` file in the root directory and configure the following variables:

```dotenv
REGION=<aws region> #defaults to us-east-1
VERSION_RETENTION_NUMBER=<number of lambda versions to keep> #defaults to 3
LOG_RETENTION_DAYS=<number of days to keep log data> #defaults to 7
DJANGO_SECRET_KEY=<django secret key>
DJANGO_SUPERUSER_USERNAME=<username of superuser django admin>
DJANGO_SUPERUSER_PASSWORD=<password of superuser django admin>
DJANGO_SUPERUSER_EMAIL=<email of superuser django admin>
SQLITE_DB_NAME=<name of sqlite db> #defaults to database.db
AWS_S3_BUCKET_DB=<aws s3 bucket to store sqlite db from ssm /staging/bucket/db>
AWS_S3_ACCESS_KEY=<aws iam user key from ssm /staging/s3-user/access-key>
AWS_S3_ACCESS_SECRET=<aws iam user secret from ssm /staging/s3-user/access-secret>
```

- Install packages: `npm install`
- Deploy on AWS: `npx sls deploy -s staging`

## Running on AWS (Production)

- Put AWS credentials on your PC
- Go to infra staging resources: `cd infra/prod`
- Initialize terraform: `terraform init`
- Create all resources: `terraform apply`
- Create `.env.prod` file in the root directory and configure the following variables:

```dotenv
REGION=<aws region> #defaults to us-east-1
VERSION_RETENTION_NUMBER=<number of lambda versions to keep> #defaults to 3
LOG_RETENTION_DAYS=<number of days to keep log data> #defaults to 7
DJANGO_SECRET_KEY=<django secret key>
DJANGO_SUPERUSER_USERNAME=<username of superuser django admin>
DJANGO_SUPERUSER_PASSWORD=<password of superuser django admin>
DJANGO_SUPERUSER_EMAIL=<email of superuser django admin>
AWS_S3_BUCKET_STORAGE=<aws s3 bucket to store static and media files from ssm /prod/bucket/storag>
AWS_S3_ACCESS_KEY=<aws iam user key from ssm /prod/s3-user/access-key>
AWS_S3_ACCESS_SECRET=<aws iam user secret from ssm /prod/s3-user/access-secret>
RDS_MYSQL_DB_HOST=<aws endpoint of rds aurora database from ssm /prod/database/endpoint>
RDS_MYSQL_DB_NAME=<name of mysql db from ssm /prod/database/name>
RDS_MYSQL_DB_USER=<master username of mysql db from ssm /prod/database/user>
RDS_MYSQL_DB_PASSWORD=<master password of mysql db from ssm /prod/database/password>
```

- Deploy on AWS: `npx sls deploy -s prod`

## TODO

- [x] Instructions to running locally and in the cloud
- [x] Sqlite Database on S3 (staging)
- [x] Saving static and media files on S3 (production)
- [x] Running unit tests on deploy
- [x] Custom logs on CloudWatch
- [x] Enable/disable Django debug on lambda config
- [x] Serverless support for local/multiple environments
- [x] CloudWatch alarms configuration (production)
- [x] Resource's infrastructure as code
- [ ] AWS architecture diagram (staging and production)
- [ ] CI/CD pipelines
- [ ] Sqlite Database on EFS (staging)
