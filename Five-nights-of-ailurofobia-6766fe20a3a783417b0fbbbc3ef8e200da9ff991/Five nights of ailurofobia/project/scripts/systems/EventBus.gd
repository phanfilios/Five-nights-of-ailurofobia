extends Node
class_name EventBus

signal stage_changed
signal night_started
signal night_finished

signal threat_level_changed(threat: float)
signal risk_level_changed(risk: float)
signal animatronic_attack
signal power_out

signal update_clock(hour: int)
signal update_power(power: float)
signal update_noise(noise: float)

signal game_over
signal victory
signal audio_event(event_name: String)
