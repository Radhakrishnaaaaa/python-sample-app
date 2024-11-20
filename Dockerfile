FROM ubuntu:latest

WORKDIR /app

COPY requirements.txt /app
COPY devops /app

RUN apt-get update
RUN apt-get install -y python3 
RUN apt install python3-pip -y
RUN apt install python3.12-venv -y
RUN python3 -m venv /app/venv
RUN . /app/venv/bin/activate
RUN /app/venv/bin/pip install -r requirements.txt
RUN cd devops

ENTRYPOINT ["/app/venv/bin/python3"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]
