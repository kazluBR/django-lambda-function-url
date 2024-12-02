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

![alt text](/images/staging-architecture.jpg)

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
DJANGO_SECRET_KEY=<django secret key from ssm /staging/django-secret-key>
DJANGO_SUPERUSER_USERNAME=<username of superuser django admin> #defaults to admin
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

![alt text](/images/prod-architecture.jpg)

- Put AWS credentials on your PC
- Go to infra production resources: `cd infra/production`
- Initialize terraform: `terraform init`
- Create all resources: `terraform apply`
- Create `.env.production` file in the root directory and configure the following variables:

```dotenv
REGION=<aws region> #defaults to us-east-1
VERSION_RETENTION_NUMBER=<number of lambda versions to keep> #defaults to 3
LOG_RETENTION_DAYS=<number of days to keep log data> #defaults to 7
DJANGO_SECRET_KEY=<django secret key from ssm /production/django-secret-key>
DJANGO_SUPERUSER_USERNAME=<username of superuser django admin> #defaults to admin
DJANGO_SUPERUSER_PASSWORD=<password of superuser django admin>
DJANGO_SUPERUSER_EMAIL=<email of superuser django admin>
AWS_S3_BUCKET_STORAGE=<aws s3 bucket to store static and media files from ssm /production/bucket/storage>
AWS_S3_ACCESS_KEY=<aws iam user key from ssm /production/s3-user/access-key>
AWS_S3_ACCESS_SECRET=<aws iam user secret from ssm /production/s3-user/access-secret>
RDS_MYSQL_DB_HOST=<aws endpoint of rds aurora database from ssm /production/database/endpoint>
RDS_MYSQL_DB_NAME=<name of mysql db from ssm /production/database/name>
RDS_MYSQL_DB_USER=<master username of mysql db from ssm /production/database/user>
RDS_MYSQL_DB_PASSWORD=<master password of mysql db from ssm /production/database/password>
```

- Deploy on AWS: `npx sls deploy -s production`

## CI/CD Configuration

- Follow the steps to configure a github actions OIDC Provider on AWS: https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
- Configure staging and production environments in your github repository
- Create the respective secrets in each environment with the same name as in `.env.{stage}`
- Create the AWS_ASSUME_ROLE secret in each of the environments with the arn of the role created in the first step.
- Now you can see the pipeline working [aqui](https://github.com/kazluBR/django-lambda-function-url/actions). When pushing the staging branch, the deploy will update the staging environment and when doing it in the master, the production environment.

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
- [x] AWS architecture diagram (staging and production)
- [x] CI/CD pipelines
- [ ] Sqlite Database on EFS (staging)
