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

\*_Don't support upload of media files_

\*_Concurrent writes will often be lost and not show up in concurrent readers. This is because the database is transferred between S3 storage and the Lambda instance for each request_

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
DJANGO_SUPERUSER_USERNAME=<username of superuser django admin>
DJANGO_SUPERUSER_PASSWORD=<password of superuser django admin>
DJANGO_SUPERUSER_EMAIL=<email of superuser django admin>
SQLITE_DB_NAME=<name of sqlite db> #defaults to database.db
AWS_S3_BUCKET_DB=<aws s3 bucket to store sqlite db>
AWS_S3_ACCESS_KEY=<aws iam user key>
AWS_S3_ACCESS_SECRET=<aws iam user secret>
```

- Install packages: `npm install`
- Put AWS credentials on your PC
- Deploy on AWS: `npx sls deploy -s staging`

## Running on AWS (Production)

- Create RDS Aurora Mysql database with your desired configuration
  - Enable Publicly accessible
  - Add your IP on security group's inbound rule of your database with type MYSQL/Aurora
- Create VPC Endpoint type Gateway to service `com.amazonaws.{region}.s3`
- Create bucket on AWS S3 to store static and media files
  - Uncheck Block all public access
  - Enable ACLs on Object Ownership
- Create IAM User with access key and attach a policy like that:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
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
DJANGO_SUPERUSER_USERNAME=<username of superuser django admin>
DJANGO_SUPERUSER_PASSWORD=<password of superuser django admin>
DJANGO_SUPERUSER_EMAIL=<email of superuser django admin>
AWS_S3_BUCKET_STORAGE=<aws s3 bucket to store static and media files>
AWS_S3_ACCESS_KEY=<aws iam user key>
AWS_S3_ACCESS_SECRET=<aws iam user secret>
RDS_MYSQL_DB_HOST=<aws endpoint of rds aurora database>
RDS_MYSQL_DB_NAME=<name of mysql db>
RDS_MYSQL_DB_USER=<master username of mysql db>
RDS_MYSQL_DB_PASSWORD=<master password of mysql db>
SECURITY_GROUP_ID=<aws security group id of rds database>
SUBNET_ID=<aws subnet id of rds database>
```

- Put AWS credentials on your PC
- Deploy on AWS: `npx sls deploy -s prod`

## TODO

- [x] Instructions to running locally and in the cloud
- [x] Sqlite Database on S3 (staging)
- [x] Saving static and media files on S3 (production)
- [x] Running unit tests on deploy
- [x] Custom logs on CloudWatch
- [x] Enable/disable Django debug on lambda config
- [x] Serverless support for local/multiple environments
- [ ] AWS architecture diagram (staging and production)
- [ ] CI/CD pipelines
- [ ] Resource's infrastructure as code
- [ ] Sqlite Database on EFS (staging)
