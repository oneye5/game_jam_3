extends Camera2D

@export var increment = 10
@export var min = 1
@export var max = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_released("zoom_in"):
		var add = (increment * delta) * Vector2.ONE
		var new = zoom + add
		var zoom_mag = sqrt((new.x*new.x) + (new.y*zoom.y))
		if zoom_mag < max:
			zoom = new
			
		
	if Input.is_action_just_pressed("zoom_out"):
		var add = (increment * delta) * Vector2.ONE
		var new = zoom - add
		var zoom_mag = sqrt((new.x*new.x) + (new.y*zoom.y))
		if zoom_mag > min:
			zoom = new
	
