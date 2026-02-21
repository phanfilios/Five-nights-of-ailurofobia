extends Node
class_name DirectorAI

var night_manager
var animatronics = []

var global_difficulty = 1.0
var max_difficulty = 3.0




func setup(nm, ai_list):
	night_manager = nm
	animatronics = ai_list




func update(delta):
	update_difficulty()
	apply_difficulty()




func update_difficulty():
	var hour = night_manager.current_hour
	
	# Escalado progresivo por hora
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




func apply_difficulty():
	for ai in animatronics:
		ai.base_aggression *= global_difficulty