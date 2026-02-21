extends Node
class_name GameStage

signal stage_changed
signal invalid_transition_attempt

enum Stage {
    MENU,
    TYCOON,
    NIGHT,
    SALVAGE,
    GAME_OVER,
    VICTORY
}

var current_stage = Stage.MENU

var allowed_transitions = {
    Stage.MENU:      [Stage.TYCOON, Stage.NIGHT],
    Stage.TYCOON:    [Stage.NIGHT],
    Stage.NIGHT:     [Stage.SALVAGE, Stage.GAME_OVER, Stage.VICTORY],
    Stage.SALVAGE:   [Stage.NIGHT, Stage.GAME_OVER],
    Stage.GAME_OVER: [Stage.MENU],
    Stage.VICTORY:   [Stage.MENU]
}


func change_stage(new_stage):
    if new_stage == current_stage:
        return false

    if not allowed_transitions.has(current_stage):
        invalid_transition_attempt.emit()
        return false

    if new_stage in allowed_transitions[current_stage]:
        current_stage = new_stage
        stage_changed.emit()
        return true
    else:
        invalid_transition_attempt.emit()
        return false


func is_stage(stage):
    return current_stage == stage


func reset_to_menu():
    current_stage = Stage.MENU
    stage_changed.emit()