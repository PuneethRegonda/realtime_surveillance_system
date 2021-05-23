# capture images and make database
import os
import numpy as np
import cv2
from PIL import Image

try:
    cam = cv2.VideoCapture("C:/Users/17211/Desktop/rakesh_sample.mp4")
    # cam = cv2.VideoCapture("C:/Users/17211/Desktop/vijay_sample.mp4")
    # cam = cv2.VideoCapture("C:/Users/17211/Desktop/chakri_sample.mp4")
    # cam = cv2.VideoCapture(0)
    
    cam.set(3, 640) # set video width
    cam.set(4, 480) # set video height

    face_detector = cv2.cv2.CascadeClassifier('D:/puneeth/facemap/src/cascades/data/haarcascade_frontalface_default.xml')

    folder_name = input("Enter folder name to save photos in it\n")
    
    # print("creating folder {}\n".format(folder_name))
    created_folder_path = "D:/puneeth/facemap/src/images/{}".format(folder_name)
    print("created folder\n",os.mkdir(created_folder_path))

    face_id = input('\n enter user faceid i.e to save photo as face_id.count\n')
    print("\n [INFO] Initializing face capture. Look the camera and wait ...")# Initialize individual sampling face count
    count = 0
    
    while(True):
        ret, img = cam.read()
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        faces = face_detector.detectMultiScale(
            gray,
            scaleFactor=1.3,
            minNeighbors=5,
        )

        for (x,y,w,h) in faces:
            # cv2.rectangle(img, (x,y), (x+w,y+h), (0,255,0), 2)     
            count += 1
            # Save the captured image into the datasets folder img[y:y+h,x:x+w]
            # cv2.imwrite("D:/puneeth/facemap/src/images/{}/".format(folder_name) + str(face_id) + '.' +  str(count) + ".jpg", gray[y:y+h,x:x+w])
            cv2.imwrite("D:/puneeth/facemap/src/images/{}/".format(folder_name) + str(face_id) + '.' +  str(count) + ".jpg", img)
            
            cv2.imshow('image', img)
        if cv2.waitKey(100) & 0xff==ord('q'):
            break
        elif count >= 100: # Take 30 face sample and stop video
             break# Do a bit of cleanup
    print("\n [INFO] Exiting Program and cleanup stuff")
except Exception as e:
    print(e)
cam.release()
cv2.destroyAllWindows()