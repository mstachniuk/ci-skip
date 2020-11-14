#!/bin/bash

docker build --tag ciskipbats:latest .

docker run -it -v "${PWD}:/code" ciskipbats:latest /code/test