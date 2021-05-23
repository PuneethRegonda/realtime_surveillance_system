# test recognizer
import os
import numpy as np
import cv2
from PIL import Image


class Recognizer:
    
    def __init__(self):
        print("initializing Recognizer")
        pass
    
    def train(self):
        try:
            print("training ")
            # BASE_DIR = os.path.dirname(os.path.abspath(__file__)) this says where is this notebook exactly is..

            recognizer = cv2.face.LBPHFaceRecognizer_create()

            faces_got,ids = self.getImageAndLabels("D:/puneeth/facemap/src/dataset")
            recognizer.train(faces_got, np.array(ids))

            # Save the model into recognizers/trainer.yml
            recognizer.write('D:/puneeth/facemap/src/recognizers/trainer.yml')

            print("Saved the model into recognizers/trainer.yml")
        except Exception as e:
            print(e)
        
    def getImageAndLabels(self,path):
            face_cascade = cv2.CascadeClassifier('cascades/data/haarcascade_frontalface_default.xml')
            
            print("getting all face_vectors and face_labels")
            imagePaths = [os.path.join(path,f) for f in os.listdir(path)]     
            print(imagePaths)
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
            recognizer.read('D:/puneeth/facemap/src/recognizers/trainner.yml')
            # recognizer.read('D:/puneeth/facemap/src/recognizers/trainner.yml')

            faceCascade = cv2.CascadeClassifier('cascades/data/haarcascade_frontalface_alt.xml')
            font = cv2.FONT_HERSHEY_SIMPLEX

            id = 0
            names = ['','17211a1289','17211a1291','17211a1287']
#             url = input()
            cam = cv2.VideoCapture(0)
            cam.set(3, 640) # set video widht
            cam.set(4, 480) # set video height

            while True:

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
                    break
                    # before ending its complusory we release resources 

        except Exception as e:
            print(e)
                
        cam.release()
        cv2.destroyAllWindows()
   
reco = Recognizer()

reco.recognize()
