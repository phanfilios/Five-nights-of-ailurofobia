extends Node
class_name PowerSystem


var max_power = 100.0
var current_power = 100.0

var base_drain_rate = 0.5
var extra_drain = 0.0

var power_out_triggered = false




func reset():
	current_power = max_power
	extra_drain = 0.0
	power_out_triggered = false
	EventBus.update_power.emit(current_power)




func add_power_usage(amount):
	extra_drain += amount

func reduce_power_usage(amount):
	extra_drain -= amount
	
	if extra_drain < 0:
		extra_drain = 0




func update(delta):
	if power_out_triggered:
		return
	
	var total_drain = base_drain_rate + extra_drain
	current_power -= total_drain * delta
	
	EventBus.update_power.emit(current_power)
	
	if current_power <= 20 and current_power > 0:
		trigger_low_power_effect()
	
	if current_power <= 0:
		trigger_power_out()




func trigger_low_power_effect():
	EventBus.update_noise.emit(5)  # Simula inestabilidad



func trigger_power_out():
	power_out_triggered = true
	current_power = 0
	EventBus.power_out.emit()
	EventBus.animatronic_attack.emit()