extends Node
class_name NightController

var night_manager
var threat_system
var power_system
var animatronics = []

var is_active = false




func setup(nm, ts, ps, ai_list):
	night_manager = nm
	threat_system = ts
	power_system = ps
	animatronics = ai_list



func start_night():
	is_active = true
	
	threat_system.reset()
	power_system.reset()
	
	for ai in animatronics:
		ai.reset()
	
	night_manager.start_night()




func update(delta):
	if not is_active:
		return
	
	night_manager.update(delta)
	power_system.update(delta)
	
	# Reducir amenaza lentamente
	threat_system.reduce_threat(0.2 * delta)
	
	for ai in animatronics:
		ai.update(delta)




func stop_night():
	is_active = false