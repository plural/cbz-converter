FROM python:3 as python

RUN pip3 install img2pdf 
RUN apt update
RUN apt install -y imagemagick zip unzip ghostscript optipng vim

COPY src /src/
