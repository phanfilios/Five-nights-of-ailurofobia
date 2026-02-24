extends Node
class_name GameState

signal state_changed
signal invalid_transition_attempt

enum Stage {
	MENU,
	TYCOON,
	NIGHT,
	SALVAGE,
	GAME_OVER,
	VICTORY
}

var current_stage := Stage.MENU

var allowed_transitions := {
	Stage.MENU: [Stage.TYCOON, Stage.NIGHT],
	Stage.TYCOON: [Stage.NIGHT],
	Stage.NIGHT: [Stage.SALVAGE, Stage.GAME_OVER, Stage.VICTORY],
	Stage.SALVAGE: [Stage.NIGHT, Stage.GAME_OVER],
	Stage.GAME_OVER: [Stage.MENU],
	Stage.VICTORY: [Stage.MENU]
}


func change_stage(new_stage: Stage) -> bool:
	if new_stage == current_stage:
		return false

	if not allowed_transitions.has(current_stage):
		invalid_transition_attempt.emit()
		return false

	if new_stage in allowed_transitions[current_stage]:
		current_stage = new_stage
		state_changed.emit()
		EventBus.stage_changed.emit()
		return true

	invalid_transition_attempt.emit()
	return false


func is_stage(stage: Stage) -> bool:
	return current_stage == stage


func reset_to_menu() -> void:
	current_stage = Stage.MENU
	state_changed.emit()
	EventBus.stage_changed.emit()
