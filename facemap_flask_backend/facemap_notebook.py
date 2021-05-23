
import sys
import requests
import socketio
import cv2
import os
import numpy as np
from PIL import Image
import pickle
import random

print(cv2.__file__)

TOKEN =""



class Recognizer:

    def __init__(self,socket):
        self.socket =socket
        self.stop = False
        print("initializing Recognizer")
        pass
    
    def disconnect(self):
        self.socket.disconnect()

    def train(self):
        try:
            print("training ")
            # BASE_DIR = os.path.dirname(os.path.abspath(__file__)) this says where is this notebook exactly is..

            recognizer = cv2.face.LBPHFaceRecognizer_create()

            faces_got,ids = self.getImageAndLabels("./dataset/")
            recognizer.train(faces_got, np.array(ids))

            # Save the model into recognizers/trainer.yml
            recognizer.write('recognizers/trainner.yml')

            print("Saved the model into recognizers/trainer.yml")
        except Exception as e:
            print(e)
        
    def getImageAndLabels(self,path):
            face_cascade = cv2.CascadeClassifier('cascades/data/haarcascade_frontalface_default.xml')
            
            print("getting all face_vectors and face_labels")
            imagePaths = [os.path.join(path,f) for f in os.listdir(path)]     
        #     print(len(imagePaths))
            faceSamples=[]
            ids = []
            for root, dirs, files_names in os.walk(path):
                total_files = 0
                detected_faces = 0
                if(root==path):
                    continue
                for file in files_names:
                    if file.endswith("png") or file.endswith("jpg") or file.endswith("JPG"):
                        total_files = total_files+1
                        image_path = os.path.join(root, file)
                        PIL_img = Image.open(image_path).convert('L') # convert it to grayscale
                        img_numpy = np.array(PIL_img,'uint8')

                        # print(os.path.split(file)) ('', '1.194.jpg')
                        # os.path.split(file)[-1].split(".") --->>> ['1', '194', 'jpg']

                        label_id = int(os.path.split(file)[-1].split(".")[0])
                        faces = face_cascade.detectMultiScale(img_numpy) 

                        for (x,y,w,h) in faces:
                            detected_faces = detected_faces+1
                            faceSamples.append(img_numpy[y:y+h,x:x+w])
                            ids.append(label_id)
                print("root:",root,end='\n')
                print("DIR:",len(dirs),end='\n')
                print("Files:",len(files_names))
                print("total images:"+str(total_files))
                print("detected_faces:" +str(detected_faces))
            return faceSamples,ids
        

        
    def recognize(self):
        
        try:
            recognizer = cv2.face.LBPHFaceRecognizer_create()
#             recognizer.read('recognizers/trainner.yml')
            recognizer.read('recognizers/trainner_3_but_better.yml')

            faceCascade = cv2.CascadeClassifier('cascades/data/haarcascade_frontalface_alt.xml')
            font = cv2.FONT_HERSHEY_SIMPLEX

            id = 0
            names = ['', '', 'Priyanka Chopra',"Puneeth","Tiger Shroff","Vicky Kaushal","Shah_Rukh_Khan"]
#             url = input()
            cam = cv2.VideoCapture(0)
            cam.set(3, 640) # set video widht
            cam.set(4, 480) # set video height

            while True:
                if self.stop:
                    self.socket.disconnect()
                    break

                ret, img =cam.read()
                gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

                faces = faceCascade.detectMultiScale( 
                    gray,
                    scaleFactor = 1.2,
                    minNeighbors = 3,
                   )
                
#                 after detecting faces from the frame its time for predicting the faces
                for(x,y,w,h) in faces:
                    cv2.rectangle(img, (x,y), (x+w,y+h), (0,255,0), 2)
                    id, confidence = recognizer.predict(gray[y:y+h,x:x+w])

                    # If confidence is less then 100 ==> "0" : perfect match 
                    if (confidence < 100):
                        sio.emit('push_faces', {'location': random.choice(locations),'name':names[id]}, namespace='/facemap')                    
                        id = names[id]
                        confidence = "  {0}%".format(round(100 - confidence))

                    else:
                        id = "unknown"
                        confidence = "  {0}%".format(round(100 - confidence))

                    cv2.putText(
                                img, 
                                str(id), 
                                (x+5,y-5), 
                                font, 
                                1, 
                                (255,255,255), 
                                2
                               )
                    cv2.putText(
                                img, 
                                str(confidence), 
                                (x+5,y+h-5), 
                                font, 
                                1, 
                                (255,255,0), 
                                1
                               )  

                cv2.imshow('camera',img) 
                if cv2.waitKey(10) & 0xff==ord("q"):
                    self.socket.disconnect()
                    break
                    # before ending its complusory we release resources 

        except Exception as e:
            print(e)
                
        cam.release()
        cv2.destroyAllWindows()
   


# In[7]:




# Socket Manager

# sio = socketio.Client(logger=True)
sio = socketio.Client()


@sio.event
def connect_error():
    print("The connection failed!")    
    
@sio.event
def disconnect():
    print("disconnected")
    
# just for testing
@sio.on('new_faces', namespace='/facemap')
def new_faces(data):
    print("new faces")
    print(data)
    return "OK", 123

@sio.on('old_faces', namespace='/facemap')
def old_faces(data):
    print("old faces")
    print(data)
    return "OK", 123

@sio.on('param_error', namespace='/facemap')
def param_error(data):
    print("param_error")
    print(data)
    return "OK", 123

@sio.on('connect', namespace='/facemap')
def on_connect():
    print("Start Pushing the faces and Locations of people")

@sio.on('disconnect', namespace='/facemap')
def on_disconnect():
    print("on disconnect")
    _host
sio.connect(_host,headers={'Authorization':'TOKEN '+TOKEN}, namespaces=['/facemap'])    
# sio.connect('https://face-map-node-server.herokuapp.com',headers={'Authorization':'TOKEN '+TOKEN}, namespaces=['/facemap'])


# In[8]:


# Recognizer
# sio.emit('push_faces', {'location': 'FoodCourt'}, namespace='/facemap')


# Recognizer has 
#     * Train 
#     * Recognize
# 

# In[9]:


recognizer = Recognizer(sio)
# recognizer.train()
recognizer.recognize()
# recognizer.capture()
# rtsp://192.168.0.5:8080/h264_pcm.sdp


# In[10]:


# recognizer.disconnect()


# In[129]:


#print(help(cv2.face))


# In[22]:


recognizer.recognize()


# In[10]:





# In[ ]:




