extends Node

# ===============================
# REFERENCIAS SEGURAS
# ===============================

@onready var world_3d: Node3D = get_node_or_null("World3D")
@onready var world_2d: Node2D = get_node_or_null("World2D")
@onready var game_manager: Node = get_node_or_null("GameManager")
@onready var fx_manager: Node = get_node_or_null("FXManager")
@onready var ui: Node = get_node_or_null("UI")




enum VisualMode {
    MODE_3D,
    MODE_2_5D,
    MODE_PIXEL
}

var current_mode: VisualMode = VisualMode.MODE_2_5D
var psychedelic_intensity: float = 0.2
var time_passed: float = 0.0




func _ready() -> void:
    print("Main inicializado correctamente")

    _validate_nodes()
    _configure_visual_mode(current_mode)
    _connect_signals()




func _validate_nodes() -> void:
    if not game_manager:
        push_error("GameManager no encontrado.")
    if not world_3d:
        push_warning("World3D no encontrado.")
    if not world_2d:
        push_warning("World2D no encontrado.")



func _connect_signals() -> void:
    if game_manager:
        if game_manager.has_signal("game_over"):
            game_manager.game_over.connect(_on_game_over)
        if game_manager.has_signal("victory"):
            game_manager.victory.connect(_on_victory)




func _process(delta: float) -> void:
    time_passed += delta
    _apply_psychedelic_effect(delta)




func _configure_visual_mode(mode: VisualMode) -> void:
    match mode:
        VisualMode.MODE_3D:
            if world_3d: world_3d.visible = true
            if world_2d: world_2d.visible = false

        VisualMode.MODE_2_5D:
            if world_3d: world_3d.visible = true
            if world_2d: world_2d.visible = true

        VisualMode.MODE_PIXEL:
            if world_3d: world_3d.visible = false
            if world_2d: world_2d.visible = true


func switch_mode(new_mode: VisualMode) -> void:
    current_mode = new_mode
    _configure_visual_mode(current_mode)




func _apply_psychedelic_effect(delta: float) -> void:
    if world_3d:
        world_3d.rotation.y += psychedelic_intensity * delta

    if world_2d and current_mode == VisualMode.MODE_2_5D:
        world_2d.position.x = sin(time_passed) * 5.0
        world_2d.position.y = cos(time_passed * 0.5) * 3.0



func _on_game_over(reason: String) -> void:
    print("Game Over:", reason)

    if fx_manager and fx_manager.has_method("trigger_glitch"):
        fx_manager.trigger_glitch()

    if ui and ui.has_method("show_game_over"):
        ui.show_game_over(reason)


func _on_victory() -> void:
    print("Victoria")

    if fx_manager and fx_manager.has_method("trigger_flash"):
        fx_manager.trigger_flash()

    if ui and ui.has_method("show_victory"):
        ui.show_victory()