FROM public.ecr.aws/lambda/python:3.9

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV LD_LIBRARY_PATH "/usr/local/lib/"

WORKDIR /${LAMBDA_TASK_ROOT}

RUN python -m pip install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

RUN yum install sudo -y
RUN sudo yum install -y wget tar make gcc
RUN cd ~ && wget https://www.sqlite.org/2021/sqlite-autoconf-3350500.tar.gz && tar xzf sqlite-autoconf-3350500.tar.gz && cd sqlite-autoconf-3350500 && ./configure && make && make install

CMD ["django_lambda.wsgi.handler"]