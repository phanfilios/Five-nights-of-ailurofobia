extends Node
class_name AnimatronicAI


var name_id = "Unknown"

var base_aggression = 5.0
var noise_sensitivity = 1.0
var heat_sensitivity = 1.0

var patience = 100.0
var decision_interval = 3.0




enum AIState {
	IDLE,
	HUNTING,
	STALKING,
	ATTACKING,
	RETREATING
}

var current_state = AIState.IDLE
var decision_timer = 0.0
var attack_probability = 0.0




func reset():
	current_state = AIState.IDLE
	patience = 100.0
	decision_timer = 0.0
	attack_probability = 0.0




func update(delta):
	decision_timer += delta
	
	if decision_timer >= decision_interval:
		decision_timer = 0.0
		make_decision()




func make_decision():
	var threat = ThreatSystem.current_threat
	var power = PowerSystem.current_power
	
	var aggression_factor = base_aggression
	aggression_factor += threat * noise_sensitivity
	aggression_factor += (100 - power) * heat_sensitivity
	
	attack_probability = aggression_factor / 200.0
	
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




func change_state(new_state):
	current_state = new_state



func trigger_attack():
	EventBus.animatronic_attack.emit()
	change_state(AIState.RETREATING)
	patience = 50.0