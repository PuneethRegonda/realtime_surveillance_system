from flask import Flask,request,Response,jsonify, make_response
from flask_cors import CORS, cross_origin

from recognizer import Recognizer;
import cv2
import base64
import numpy as np


app = Flask(__name__)

@app.route('/')
def application():
    return "<center><h1>You are Hacked!!</h1></center>"

@app.route('/recognizer',methods=['POST'])
@cross_origin()
def recognizer():
    try:
        print(request)    
        file = request.files['image']
        image = cv2.imdecode(np.fromstring(file.read(), np.uint8), cv2.IMREAD_UNCHANGED)
        # print(type(image))        
        
        recognizer_a = Recognizer()
        faces  = recognizer_a.detect_faces(image)
        
        if(len(faces)==1):
            image,userID,confidence= recognizer_a.recognize_uploaded_pic(image,faces)
            print(userID)            
            image_content = cv2.imencode('.jpg', image)[1].tostring()
            # encoded_image = base64.encodestring(image_content)
            encoded_image = base64.b64encode(image_content).decode('ascii')
            
            if userID == "unknown":
                response = jsonify(message="Unkown Face Detected.",status=False,data={"user_id":userID,"image":encoded_image,"confidence":confidence})
            else:            
                response = jsonify(message="Face Recognized.",status=True,data={"user_id":userID,"image":encoded_image,"confidence":confidence})
        elif(len(faces)==0):
            response = jsonify(message="No face detected.",status=False)
        elif(len(faces)>0):
            response = jsonify(message="More than one Faces are detected.",status=False)            
        return response 

    except Exception as e:
        print("error gotcha")
        print(str(e))
        return {"message":"Falied","status":False,"error":str(e)}
