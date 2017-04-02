FROM tiangolo/uwsgi-nginx-flask:flask

COPY requirements.txt /app
RUN pip install -r /app/requirements.txt

COPY . /app
