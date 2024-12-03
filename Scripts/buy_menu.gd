extends CanvasLayer
@onready var buy_panel = $Panel
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("buy_menu"):
		if buy_panel.visible:
			buy_panel.visible = false
			get_tree().paused = false
		else:
			buy_panel.visible = true
			get_tree().paused = true
		
