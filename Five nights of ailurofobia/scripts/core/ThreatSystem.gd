extends Node
class_name ThreatSystem

# =========================
# VARIABLES DE RIESGO
# =========================

var noise_level = 0.0
var heat_level = 0.0
var activity_level = 0.0

var max_threshold = 100.0
var current_threat = 0.0

var attack_triggered = false


# =========================
# RESETEAR SISTEMA
# =========================

func reset():
	noise_level = 0.0
	heat_level = 0.0
	activity_level = 0.0
	current_threat = 0.0
	attack_triggered = false




func add_noise(amount):
	noise_level += amount
	update_threat()

func add_heat(amount):
	heat_level += amount
	update_threat()

func add_activity(amount):
	activity_level += amount
	update_threat()




func update_threat():
	current_threat = noise_level + heat_level + activity_level
	
	EventBus.threat_level_changed.emit(current_threat)
	
	if current_threat >= max_threshold and not attack_triggered:
		trigger_attack()




func trigger_attack():
	attack_triggered = true
	EventBus.animatronic_attack.emit()




func reduce_threat(amount):
	current_threat -= amount
	
	if current_threat < 0:
		current_threat = 0