extends Node
class_name ConfigSystem

static var config := {
	"master_volume": 0.8,
	"music_volume": 0.7,
	"sfx_volume": 0.85,
	"fullscreen": false
}


static func get_value(key: String, default_value = null):
	return config.get(key, default_value)


static func set_value(key: String, value) -> void:
	config[key] = value
