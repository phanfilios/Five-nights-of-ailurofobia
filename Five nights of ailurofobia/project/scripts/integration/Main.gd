extends Node
class_name Main

var night_manager: NightManager
var threat_system: ThreatSystem
var power_system: PowerSystem
var director_ai: DirectorAI
var animatronics: Array[AnimatronicAI] = []

var is_active := false


func setup(nm: NightManager, ts: ThreatSystem, ps: PowerSystem, director: DirectorAI, ai_list: Array[AnimatronicAI]) -> void:
	night_manager = nm
	threat_system = ts
	power_system = ps
	director_ai = director
	animatronics = ai_list
	director_ai.setup(night_manager, animatronics)


func start_night() -> void:
	is_active = true
	threat_system.reset()
	power_system.reset()
	RiskSystem.reset()

	for ai in animatronics:
		ai.reset()

	night_manager.start_night()


func update(delta: float) -> void:
	if not is_active:
		return

	night_manager.update(delta)
	power_system.update(delta)
	threat_system.reduce_threat(0.2 * delta)
	director_ai.update(delta)

	for ai in animatronics:
		ai.update(delta)


func stop_night() -> void:
	is_active = false
