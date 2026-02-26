extends PanelContainer
class_name MainConfigUI

signal request_back

@onready var fullscreen_check: CheckBox = $Margin/VBox/FullscreenCheck
@onready var master_slider: HSlider = $Margin/VBox/MasterRow/MasterSlider
@onready var music_slider: HSlider = $Margin/VBox/MusicRow/MusicSlider
@onready var sfx_slider: HSlider = $Margin/VBox/SFXRow/SFXSlider
@onready var values_label: Label = $Margin/VBox/ValuesLabel


func _ready() -> void:
	$Margin/VBox/Buttons/ApplyButton.pressed.connect(_on_apply_pressed)
	$Margin/VBox/Buttons/BackButton.pressed.connect(_on_back_pressed)
	master_slider.value_changed.connect(_on_value_changed)
	music_slider.value_changed.connect(_on_value_changed)
	sfx_slider.value_changed.connect(_on_value_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	load_current_config()


func load_current_config() -> void:
	fullscreen_check.button_pressed = ConfigSystem.get_value("fullscreen", false)
	master_slider.value = ConfigSystem.get_value("master_volume", 0.8)
	music_slider.value = ConfigSystem.get_value("music_volume", 0.7)
	sfx_slider.value = ConfigSystem.get_value("sfx_volume", 0.85)
	_update_values_label()


func _on_apply_pressed() -> void:
	ConfigSystem.set_value("fullscreen", fullscreen_check.button_pressed)
	ConfigSystem.set_value("master_volume", master_slider.value)
	ConfigSystem.set_value("music_volume", music_slider.value)
	ConfigSystem.set_value("sfx_volume", sfx_slider.value)
	_update_values_label()
	EventBus.audio_event.emit("menu_apply_config")


func _on_back_pressed() -> void:
	request_back.emit()


func _on_fullscreen_toggled(_enabled: bool) -> void:
	_update_values_label()


func _on_value_changed(_value: float) -> void:
	_update_values_label()


func _update_values_label() -> void:
	values_label.text = "Fullscreen: %s\nMaster: %.2f\nMusic: %.2f\nSFX: %.2f" % [
		str(fullscreen_check.button_pressed),
		master_slider.value,
		music_slider.value,
		sfx_slider.value
	]
