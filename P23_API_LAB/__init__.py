from flask import Flask, Blueprint

app = Flask(__name__)

from P23_API_LAB.API.v1.routes import people_bp

app.register_blueprint(API.v1.routes.people_bp, name ='api_v1')