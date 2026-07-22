import cv2 as cv
import mediapipe as mp
from pathlib import Path
from mediapipe.tasks import python
from mediapipe.tasks.python import vision
from ultralytics import YOLO

PROJECT_DIR = Path(__file__).resolve().parent
face_model_path = str(PROJECT_DIR / "models" / "face_landmarker.task")
object_model_path = str(PROJECT_DIR / "yolo26n.pt")

face_options = vision.FaceLandmarkerOptions(
    base_options=python.BaseOptions(
        model_asset_path=face_model_path
    ),
    running_mode=vision.RunningMode.VIDEO,
    num_faces=1
)

face_detector = vision.FaceLandmarker.create_from_options(face_options)

object_model = YOLO(object_model_path)

def track_frame(frame_rgb, frame_timestamp_ms, phone_detection=False):
    mediapipe_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=frame_rgb)
    face_result = face_detector.detect_for_video(mediapipe_image, frame_timestamp_ms)

    if not phone_detection:
        return face_result

    frame_bgr = cv.cvtColor(frame_rgb, cv.COLOR_RGB2BGR)

    # 67 is cell phone in the COCO dataset 🤷‍♂️
    phone_results = object_model.predict(source=frame_bgr, classes=[67], conf=0.35, verbose=False)

    phone_detected = False

    for result in phone_results:
        if result.boxes is not None and len(result.boxes) > 0:
            phone_detected = True
            break

    return face_result, phone_detected
