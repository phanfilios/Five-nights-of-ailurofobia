extends Node
class_name SaveSystem

static var _mock_slots := {
	"slot_1": {"night": 2, "hour": 3, "power": 68.0},
	"slot_2": {"night": 4, "hour": 1, "power": 52.0}
}


static func save_game_state(slot_id: String, data: Dictionary) -> void:
	_mock_slots[slot_id] = data
	print("Saving state in", slot_id, data)


static func load_game_state(slot_id: String) -> Dictionary:
	return _mock_slots.get(slot_id, {})


static func list_saved_games() -> Array[String]:
	return _mock_slots.keys()
