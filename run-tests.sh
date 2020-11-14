#!/bin/bash

docker build --tag ciskipbats:latest .

docker run -v "${PWD}:/code" ciskipbats:latest /code/test