extends Node
class_name NightManager

# =========================
# CONFIGURACIÓN
# =========================

var start_hour = 12
var end_hour = 6
var night_duration_seconds = 300.0  # 5 minutos reales



var current_hour = 12
var elapsed_time = 0.0
var is_running = false



func start_night():
	current_hour = start_hour
	elapsed_time = 0.0
	is_running = true
	
	EventBus.night_started.emit()
	EventBus.update_clock.emit(current_hour)




func update(delta):
	if not is_running:
		return
	
	elapsed_time += delta
	
	var hour_progress = night_duration_seconds / 6.0
	
	if elapsed_time >= hour_progress:
		elapsed_time = 0.0
		advance_hour()




func advance_hour():
	if current_hour == 12:
		current_hour = 1
	else:
		current_hour += 1
	
	EventBus.update_clock.emit(current_hour)
	
	if current_hour > end_hour:
		finish_night()




func finish_night():
	is_running = false
	EventBus.night_finished.emit()
	EventBus.victory.emit()