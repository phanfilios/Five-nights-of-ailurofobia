extends Node
class_name ConfigSystem

var config := {
	"night_duration_seconds": 300.0,
	"base_power_drain": 0.5
}


func get_value(key: String, default_value = null):
	return config.get(key, default_value)
