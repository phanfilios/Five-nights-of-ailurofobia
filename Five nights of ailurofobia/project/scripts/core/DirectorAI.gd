extends Node
class_name DirectorAI

var night_manager: NightManager
var animatronics: Array[AnimatronicAI] = []

var global_difficulty := 1.0
var max_difficulty := 3.0

var response_samples: Array[float] = []
var max_samples := 12
var avg_response_time := 2.0


func setup(nm: NightManager, ai_list: Array[AnimatronicAI]) -> void:
	night_manager = nm
	animatronics = ai_list


func update(_delta: float) -> void:
	if not night_manager:
		return
	update_difficulty()
	apply_difficulty()


func record_player_response(response_seconds: float) -> void:
	var safe_response := max(response_seconds, 0.05)
	response_samples.push_back(safe_response)
	if response_samples.size() > max_samples:
		response_samples.pop_front()

	var total := 0.0
	for sample in response_samples:
		total += sample
	avg_response_time = total / response_samples.size()
	EventBus.player_response_profile_updated.emit(avg_response_time)


func update_difficulty() -> void:
	var hour := night_manager.current_hour
	match hour:
		12:
			global_difficulty = 1.0
		1:
			global_difficulty = 1.2
		2:
			global_difficulty = 1.5
		3:
			global_difficulty = 1.8
		4:
			global_difficulty = 2.2
		5:
			global_difficulty = 2.6
		6:
			global_difficulty = max_difficulty


func _player_adaptation_factor() -> float:
	# Menor tiempo de respuesta => IA presiona más
	if avg_response_time <= 1.2:
		return 1.25
	if avg_response_time <= 2.0:
		return 1.1
	if avg_response_time <= 3.2:
		return 1.0
	return 0.9


func apply_difficulty() -> void:
	var adaptation := _player_adaptation_factor()
	for ai in animatronics:
		if ai:
			ai.current_aggression = ai.base_aggression * global_difficulty * adaptation
