extends Control
class_name MainMenuUI

@onready var panel_options: VBoxContainer = $Center/PanelOptions
@onready var panel_config: PanelContainer = $Center/ConfigPanel
@onready var panel_saves: PanelContainer = $Center/SavesPanel
@onready var saves_list: ItemList = $Center/SavesPanel/Margin/VBox/SavesList
@onready var config_summary: Label = $Center/ConfigPanel/Margin/VBox/ConfigSummary


func _ready() -> void:
	$Center/PanelOptions/PlayButton.pressed.connect(_on_play_pressed)
	$Center/PanelOptions/ConfigButton.pressed.connect(_on_config_pressed)
	$Center/PanelOptions/SavesButton.pressed.connect(_on_saves_pressed)
	$Center/ConfigPanel/Margin/VBox/BackButton.pressed.connect(_on_back_pressed)
	$Center/SavesPanel/Margin/VBox/BackButton.pressed.connect(_on_back_pressed)
	$Center/SavesPanel/Margin/VBox/LoadButton.pressed.connect(_on_load_pressed)

	_show_main_options()
	_refresh_config_view()
	_refresh_saves_view()


func _show_main_options() -> void:
	panel_options.visible = true
	panel_config.visible = false
	panel_saves.visible = false


func _on_play_pressed() -> void:
	EventBus.audio_event.emit("menu_play")
	EventBus.stage_changed.emit()
	print("Iniciar nueva partida")


func _on_config_pressed() -> void:
	_refresh_config_view()
	panel_options.visible = false
	panel_config.visible = true
	panel_saves.visible = false


func _on_saves_pressed() -> void:
	_refresh_saves_view()
	panel_options.visible = false
	panel_config.visible = false
	panel_saves.visible = true


func _on_back_pressed() -> void:
	_show_main_options()


func _on_load_pressed() -> void:
	if saves_list.get_selected_items().is_empty():
		return

	var index := saves_list.get_selected_items()[0]
	var slot_id := saves_list.get_item_text(index)
	var data := SaveSystem.load_game_state(slot_id)
	EventBus.audio_event.emit("menu_load")
	print("Cargando", slot_id, data)


func _refresh_saves_view() -> void:
	saves_list.clear()
	for slot in SaveSystem.list_saved_games():
		saves_list.add_item(slot)


func _refresh_config_view() -> void:
	var fullscreen := ConfigSystem.get_value("fullscreen", false)
	var master := ConfigSystem.get_value("master_volume", 1.0)
	var music := ConfigSystem.get_value("music_volume", 1.0)
	var sfx := ConfigSystem.get_value("sfx_volume", 1.0)
	config_summary.text = "Fullscreen: %s\nMaster: %.2f\nMusic: %.2f\nSFX: %.2f" % [
		str(fullscreen), master, music, sfx
	]


func show_game_over(reason: String) -> void:
	print("UI Game Over:", reason)


func show_victory() -> void:
	print("UI Victory")
