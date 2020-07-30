import mysql.connector
import base64
import json
import os



class cls_sql:

    def __init__(self):
        with open('/opt/output.json', 'r') as outfile:
            self.db_conection =json.load(outfile)
        self.host_name =self.db_conection["MySql_instance_IP"]["value"]                 
        self.user_name = self.db_conection["db_user_name"]["value"]
        self.user_password = self.db_conection["db_user_password"]["value"]
        self.db_name = self.db_conection["db_name"]["value"] 
        self.conn=""         
        self.query_text = ""
        self.j_body={}
        self.table_name="23people"
        self.error=""
        #self.auth_64=auth_64
        #self.get_decoded64()
        self.create_connection()
        

    def get_decoded64(self):
        self.hash_nd = self.auth_64.replace("Basic ","")
        self.hash_d = str(base64.b64decode(self.hash_nd)).replace("b'","").replace("'","")
        self.user_name = self.hash_d.split(":")[0]
        self.user_password = self.hash_d.split(":")[1]

    def create_connection(self):
        self.conn = None
        try:
            self.conn = mysql.connector.connect(
                host=self.host_name,
                user=self.user_name,
                passwd=self.user_password,
                database=self.db_name
            )
            print("Connection to MySQL DB successful")  
        except mysql.connector.Error as err:
            print("Error code:", err.msg)
        

    def execute_query(self):
        cursor = self.conn.cursor()
        try:
            query = self.query_text
            cursor.execute(query)
            self.conn.commit()
            print("Query executed successfully")
        except mysql.connector.Error as error:
            self.error = error
            print(f"The error '{error}' occurred")            
    
    def execute_read_query(self):
        cursor = self.conn.cursor()
        result = None
        try:
            query = self.query_text
            cursor.execute(query)
            result = cursor.fetchall()
            return result
        except mysql.connector.Error as error:
            self.errorFlag = error
            print(f"The error '{error}' occurred")

    def create_table(self):
        self.query_text = '''
        CREATE TABLE IF NOT EXISTS '''+self.table_name+''' (
        nationalId CHAR(15) NOT NULL, 
        name TEXT, 
        lastName TEXT, 
        age INT, 
        pictureUrl TEXT, 
        PRIMARY KEY (nationalId)
        ) ENGINE = InnoDB
        '''
        self.execute_query()



