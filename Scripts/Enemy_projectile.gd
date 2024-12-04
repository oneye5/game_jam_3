extends Area2D
@export var speed = 800
@export var damage = 5
@export var knockback = 1000

func _process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage_player(damage,Vector2.from_angle(rotation)*knockback)
		queue_free()
