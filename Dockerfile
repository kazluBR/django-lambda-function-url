FROM public.ecr.aws/lambda/python:3.9

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /${LAMBDA_TASK_ROOT}

RUN python -m pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["django_lambda.wsgi.handler"]