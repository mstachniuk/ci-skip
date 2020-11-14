FROM bats/bats:v1.1.0

RUN apk add git

COPY . /code/