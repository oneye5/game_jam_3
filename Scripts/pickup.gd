extends Area2D
@export var eat_amount = 1

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.eat_food(eat_amount)
		get_parent().queue_free()
