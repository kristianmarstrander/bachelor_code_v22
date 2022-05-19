from flask import Flask, jsonify, request
import subprocess
import os
import sys

wd = os.getcwd()
app = Flask(__name__)

@app.route("/")

def hello_world():
    return wd

@app.route("/newvm", methods=["POST"])

def new_vm():
    cmd = "../createvm.sh " + request.form['name'] + " " + request.form['os']
    os.system(cmd)
    return "New vm created"


app.run(host='0.0.0.0', port=8080)
