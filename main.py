import cv2 as cv

cam = cv.VideoCapture(0)

if not cam.isOpened():
    print("Could not open webcam")
    exit()


while True:
    # Read frame
    ret, frame = cam.read()

    if not ret:
        break

    # Display
    cv.imshow('Webcam', frame)

    # Break on 'q' key
    if cv.waitKey(1) & 0xFF == ord('q'):
        break

    # Break on exiting the window
    if cv.getWindowProperty("Webcam", cv.WND_PROP_VISIBLE) < 1:
        break

cam.release()
cv.destroyAllWindows()

