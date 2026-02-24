extends Node
class_name DirectorAI

var night_manager: NightManager
var animatronics: Array[AnimatronicAI] = []

var global_difficulty := 1.0
var max_difficulty := 3.0


func setup(nm: NightManager, ai_list: Array[AnimatronicAI]) -> void:
	night_manager = nm
	animatronics = ai_list


func update(_delta: float) -> void:
	if not night_manager:
		return
	update_difficulty()
	apply_difficulty()


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


func apply_difficulty() -> void:
	for ai in animatronics:
		if ai:
			ai.current_aggression = ai.base_aggression * global_difficulty
