# django-lambda-function-url

## A Django Project running on AWS Lambda Function Url

## Requirements

- Python 3.8
- Node 14.x
- Docker
- AWS Account

## Running Local

- Create virtual env: `python -m venv env`
- Activate virtual: `./env/Scripts/Activate.ps1`
- Upgrade pip: `python -m pip install --upgrade pip`
- Install packages: `pip install -r requirements.txt`
- Apply database migrations: `python .\django_lambda\manage.py migrate`
- Create superuser and fill the fields: `python .\django_lambda\manage.py createsuperuser`
- Run server: `python .\django_lambda\manage.py runserver`
- Access the website at link: http://localhost:8000/

## Running on AWS (Staging)

- Create bucket on AWS S3 to store sqlite db
- Create IAM User with access key and attach a policy like that:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:GetObject"],
      "Resource": "arn:aws:s3:::{YOUR_SQLITE_BUCKET_NAME}/*"
    }
  ]
}
```

- Create `.env.staging` file in the root directory and configure the following variables:

```dotenv
REGION=<aws region> #defaults to us-east-1
VERSION_RETENTION_NUMBER=<number of lambda versions to keep> #defaults to 3
LOG_RETENTION_DAYS=<number of days to keep log data> #defaults to 7
AWS_S3_DEPLOYMENT_BUCKET=<aws s3 bucket to store serverless deployment files>
DJANGO_SECRET_KEY=<django secret key>
DJANGO_SUPERUSER_USERNAME=<username to createsuperuser cmd noinput>
DJANGO_SUPERUSER_PASSWORD=<password to createsuperuser cmd noinput>
DJANGO_SUPERUSER_EMAIL=<email to createsuperuser cmd noinput>
SQLITE_DB_NAME=<name of sqlite db> #defaults to database.db
AWS_S3_BUCKET_DB=<aws s3 bucket to store sqlite db>
AWS_S3_ACCESS_KEY=<aws iam user key>
AWS_S3_ACCESS_SECRET=<aws iam user secret>
```

- Install packages: `npm install`
- Put AWS credentials on your PC
- Deploy on AWS: `npx sls deploy -s staging`

## Running on AWS (Production)

- Create bucket on AWS S3 to store sqlite db
- Create bucket on AWS S3 to store static and media files
  - UNCHECK Block all public access
  - Enable ACLs on Object Ownership
- Create IAM User with access key and attach a policy like that:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:GetObject"],
      "Resource": "arn:aws:s3:::{YOUR_SQLITE_BUCKET_NAME}/*"
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObjectAcl",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::{YOUR_STORAGE_BUCKET_NAME}/*",
        "arn:aws:s3:::{YOUR_STORAGE_BUCKET_NAME}"
      ]
    }
  ]
}
```

- Create `.env.prod` file in the root directory and configure the following variables:

```dotenv
REGION=<aws region> #defaults to us-east-1
VERSION_RETENTION_NUMBER=<number of lambda versions to keep> #defaults to 3
LOG_RETENTION_DAYS=<number of days to keep log data> #defaults to 7
AWS_S3_DEPLOYMENT_BUCKET=<aws s3 bucket to store serverless deployment files>
DJANGO_SECRET_KEY=<django secret key>
DJANGO_SUPERUSER_USERNAME=<username to createsuperuser cmd noinput>
DJANGO_SUPERUSER_PASSWORD=<password to createsuperuser cmd noinput>
DJANGO_SUPERUSER_EMAIL=<email to createsuperuser cmd noinput>
SQLITE_DB_NAME=<name of sqlite db> #defaults to database.db
AWS_S3_BUCKET_DB=<aws s3 bucket to store sqlite db>
AWS_S3_BUCKET_STORAGE=<aws s3 bucket to store static and media files>
AWS_S3_ACCESS_KEY=<aws iam user key>
AWS_S3_ACCESS_SECRET=<aws iam user secret>
```

- Put AWS credentials on your PC
- Deploy on AWS: `npx sls deploy -s prod`
