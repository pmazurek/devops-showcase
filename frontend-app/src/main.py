from flask import Flask

app = Flask(__name__)

@app.route("/")
def root():
    return "Hello, I'm an application running on Kubernetes!"
