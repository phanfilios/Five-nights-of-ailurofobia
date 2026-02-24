extends Node
class_name AudioSystem

func play_sfx(event_name: String) -> void:
	EventBus.audio_event.emit(event_name)
