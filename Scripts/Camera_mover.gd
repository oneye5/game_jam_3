extends Node2D

@export var lerpV : float = 3

func _process(delta: float) -> void:
	if manager_singleton.instance().player != null:
		position = lerp(position,manager_singleton.instance().player.position,lerpV * delta) 
