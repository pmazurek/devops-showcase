from python:3

RUN mkdir /usr/src/backend
WORKDIR /usr/src/backend

COPY requirements.txt ./
COPY src ./
RUN pip install --no-cache-dir -r requirements.txt

CMD [ "python", "main.py"]

