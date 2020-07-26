from flask import Flask,jsonify,request,render_template,Blueprint
from P23_API_LAB.API.v1.lib import sql_query
import requests
import json
import urllib.parse
#Using blueprint to soport future API versions and routes management at __init__
people_bp = Blueprint('people_bp',__name__)

@people_bp.route('/people/<int:nationalId>',methods=['GET'])
def get_people_id(nationalId):
    #creating the object
    db_obj = sql_query.cls_sql()
    response = {}
    try:
        if request.method == 'GET': #check API method  
            db_obj.create_table() 
            try:         
                #Retrive all the names
                #nationalId = urllib.parse.unquote(request.args.get('nationalId'))
                #query
                db_obj.query_text = '''SELECT * FROM people_table 
                                    where National_Id = '''+ str(nationalId)
                response["results"]= db_obj.execute_read_query()
                if response["results"] != []:
                    return response,200
                else:
                    return "Not found",404
            except:
                #Retrive all the names
                db_obj.query_text = '''SELECT * FROM people_table'''
                response["results"]=db_obj.execute_read_query()
                return response,200
    except:
        return "Not id found",404

#Provide info to api call
@people_bp.route('/people',methods=['GET'])
def get_people():
    #creating the object
    db_obj = sql_query.cls_sql()
    response = {}
    try:
        if request.method == 'GET': #check API method  
            db_obj.create_table() 
            #Retrive all the names
            db_obj.query_text = '''SELECT * FROM people_table'''
            response["results"]=db_obj.execute_read_query()
            return response,200
    except:
        return "Not id found",404

    try:
        if request.method == 'POST': #check API method  
            db_obj.create_table() 
            try:   
                #Retrive Json query      
                db_obj.j_body = request.json
                try:
                    if request.headers["Content-Type"] == "application/json":
                        db_obj.query_text = db_obj.j_body
                    else:
                        return "",500
                except:
                    return "",500

                nationalId = db_obj.j_body["nationalId"]
                name = db_obj.j_body["name"]
                age = db_obj.j_body["age"]
                pictureUrl= db_obj.j_body["pictureUrl"]
                #Add new record
                db_obj.query_text =  '''
                INSERT INTO
                `people_table` (`National_Id`, `Name`, `Last_Name`, `Age`, `Picture_Url`)
                VALUES
                ('''+nationalId+', '+name+', '+age+', '+pictureUrl+')'''
                
                db_obj.execute_query()  
                response = {}
                response["results"]= db_obj.execute_read_query() != []
                if response["results"] != []:
                    return response,201
                else:
                    return "Not id found",404
            except:
                #Retrive all the names
                return response,400
    except:
        return "Not id found",404

    
    
    



