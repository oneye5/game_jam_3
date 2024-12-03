extends Area2D
@export var add_joy = 1

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.add_joy(add_joy)
		get_parent().queue_free()
