extends Node
class_name AnimatronicAI

var name_id := "Unknown"

var base_aggression := 5.0
var current_aggression := 5.0
var noise_sensitivity := 1.0
var heat_sensitivity := 1.0

var patience := 100.0
var decision_interval := 3.0

var route_points: Array[String] = []
var route_index := 0
var move_chance := 0.35


enum AIState {
	IDLE,
	HUNTING,
	STALKING,
	ATTACKING,
	RETREATING
}

var current_state := AIState.IDLE
var decision_timer := 0.0
var attack_probability := 0.0


func setup_animatronic(animatronic_name: String, path: Array[String], aggression := 5.0) -> void:
	name_id = animatronic_name
	route_points = path.duplicate()
	base_aggression = aggression
	current_aggression = aggression
	route_index = 0


func reset() -> void:
	current_state = AIState.IDLE
	patience = 100.0
	decision_timer = 0.0
	attack_probability = 0.0
	current_aggression = base_aggression
	route_index = 0


func update(delta: float) -> void:
	decision_timer += delta

	if decision_timer >= decision_interval:
		decision_timer = 0.0
		make_decision()


func make_decision() -> void:
	var threat := ThreatSystem.current_threat
	var power := PowerSystem.current_power

	var aggression_factor := current_aggression
	aggression_factor += threat * noise_sensitivity
	aggression_factor += (100.0 - power) * heat_sensitivity

	attack_probability = clamp(aggression_factor / 200.0, 0.0, 1.0)
	RiskSystem.register_animatronic_pressure(name_id, attack_probability)

	if randf() < clamp(move_chance + attack_probability * 0.5, 0.0, 0.95):
		advance_route()

	match current_state:
		AIState.IDLE:
			if attack_probability > 0.3:
				change_state(AIState.HUNTING)

		AIState.HUNTING:
			patience -= aggression_factor * 0.1
			if patience <= 0:
				change_state(AIState.ATTACKING)

		AIState.ATTACKING:
			trigger_attack()

		AIState.RETREATING:
			patience += 10
			if patience >= 50:
				change_state(AIState.IDLE)


func advance_route() -> void:
	if route_points.is_empty():
		return
	route_index = (route_index + 1) % route_points.size()
	EventBus.animatronic_route_changed.emit(name_id, get_current_scenario_name(), route_index)


func get_current_scenario_name() -> String:
	if route_points.is_empty():
		return ""
	return route_points[route_index]


func is_in_first_scenario() -> bool:
	return route_index == 0


func change_state(new_state: AIState) -> void:
	current_state = new_state


func trigger_attack() -> void:
	EventBus.animatronic_attack.emit()
	change_state(AIState.RETREATING)
	patience = 50.0
