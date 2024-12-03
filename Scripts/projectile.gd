extends Area2D
@export var speed = 400
@export var damage = 40


func _process(delta: float) -> void:
	var extra_speed = manager_singleton.instance().projectile_level * speed / 2.0
	position += Vector2.from_angle(rotation) * (speed + extra_speed) * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy_0:
		var damage_extra = (manager_singleton.instance().damage_level * damage)/2.0
		body._damage(damage + damage_extra)
		queue_free()
