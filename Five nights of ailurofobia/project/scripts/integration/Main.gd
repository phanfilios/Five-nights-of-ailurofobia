extends Node
class_name Main

var night_manager: NightManager
var threat_system: ThreatSystem
var power_system: PowerSystem
var oxygen_system: OxygenSystem
var director_ai: DirectorAI
var animatronics: Array[AnimatronicAI] = []

var is_active := false


func setup(
	nm: NightManager,
	ts: ThreatSystem,
	ps: PowerSystem,
	os: OxygenSystem,
	director: DirectorAI,
	ai_list: Array[AnimatronicAI]
) -> void:
	night_manager = nm
	threat_system = ts
	power_system = ps
	oxygen_system = os
	director_ai = director
	animatronics = ai_list

	if animatronics.size() < 6:
		_create_default_animatronics()

	director_ai.setup(night_manager, animatronics)


func start_night() -> void:
	is_active = true
	threat_system.reset()
	power_system.reset()
	oxygen_system.reset()
	RiskSystem.reset()

	for ai in animatronics:
		ai.reset()

	night_manager.start_night()


func update(delta: float) -> void:
	if not is_active:
		return

	night_manager.update(delta)
	power_system.update(delta)
	oxygen_system.update(delta, animatronics)
	threat_system.reduce_threat(0.2 * delta)
	director_ai.update(delta)

	for ai in animatronics:
		ai.update(delta)


func register_player_response_time(response_seconds: float) -> void:
	director_ai.record_player_response(response_seconds)


func set_oxygen_trigger_scenario_name(scenario_name: String) -> void:
	oxygen_system.set_trigger_scenario_name(scenario_name)


func stop_night() -> void:
	is_active = false


func _create_default_animatronics() -> void:
	var templates := [
		{"name": "Ailuro", "path": ["Scenario_1", "Scenario_2", "Scenario_3", "Office"], "aggr": 5.0},
		{"name": "Misha", "path": ["Scenario_1", "Vent", "Office"], "aggr": 4.8},
		{"name": "Rasputin", "path": ["Scenario_1", "Storage", "Hall", "Office"], "aggr": 5.5},
		{"name": "Noctis", "path": ["Scenario_1", "LeftDoor", "Office"], "aggr": 5.2},
		{"name": "Purrlock", "path": ["Scenario_1", "Cam07", "Cam02", "Office"], "aggr": 4.9},
		{"name": "Nyx", "path": ["Scenario_1", "Ceiling", "Office"], "aggr": 5.7}
	]

	for t in templates:
		var ai := AnimatronicAI.new()
		ai.setup_animatronic(t["name"], t["path"], t["aggr"])
		animatronics.append(ai)
