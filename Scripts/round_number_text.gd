extends Label
func _ready():
	process_mode = PROCESS_MODE_ALWAYS
func _process(delta: float) -> void:
	text = "Round: " + str(manager_singleton.instance().player.enemy_manager.wave_number + 1)
