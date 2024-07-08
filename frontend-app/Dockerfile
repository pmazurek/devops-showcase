from python:3

RUN mkdir /usr/src/frontend
WORKDIR /usr/src/frontend

COPY requirements.txt ./
COPY src ./
RUN pip install --no-cache-dir -r requirements.txt

CMD [ "flask", "--app", "main", "run", "--host", "0.0.0.0" ]

