extends Area2D
@export var speed = 400
@export var damage = 40


func _process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy_0:
		body._damage(damage)
		queue_free()
