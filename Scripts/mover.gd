extends Node2D
@export var follow : Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow != null:
		position = follow.position
