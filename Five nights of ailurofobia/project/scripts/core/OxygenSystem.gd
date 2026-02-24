extends Node
class_name OxygenSystem

var max_oxygen := 100.0
var current_oxygen := 100.0
var drain_per_second := 3.0

# Puedes cambiar este nombre para decidir en qué escenario aplica.
var trigger_scenario_name := "Scenario_1"

var oxygen_depleted := false


func reset() -> void:
	current_oxygen = max_oxygen
	oxygen_depleted = false
	EventBus.oxygen_changed.emit(current_oxygen)


func set_trigger_scenario_name(scenario_name: String) -> void:
	trigger_scenario_name = scenario_name


func update(delta: float, animatronics: Array[AnimatronicAI]) -> void:
	if oxygen_depleted:
		return

	if _should_drain_oxygen(animatronics):
		current_oxygen -= drain_per_second * delta
		current_oxygen = max(current_oxygen, 0.0)
		EventBus.oxygen_changed.emit(current_oxygen)

		if current_oxygen <= 0.0:
			oxygen_depleted = true
			EventBus.oxygen_depleted.emit()


func _should_drain_oxygen(animatronics: Array[AnimatronicAI]) -> bool:
	for ai in animatronics:
		if ai and ai.is_in_first_scenario() and ai.get_current_scenario_name() == trigger_scenario_name:
			return true
	return false
