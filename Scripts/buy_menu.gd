extends CanvasLayer
@onready var buy_panel = $Panel
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	buy_panel.visible = true
	get_tree().paused = true

func _process(delta: float) -> void:
	manager_singleton.instance().player.joy_meter.value = manager_singleton.instance().player.joy
	if Input.is_action_just_pressed("buy_menu"):
		if buy_panel.visible:
			buy_panel.visible = false
			get_tree().paused = false
		else:
			buy_panel.visible = true
			get_tree().paused = true
		
