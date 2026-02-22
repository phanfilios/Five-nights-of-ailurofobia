extends Node
class_name CameraController

var current_camera := "office"


func switch_to(camera_id: String) -> void:
	current_camera = camera_id
	print("Camera switched to", camera_id)
