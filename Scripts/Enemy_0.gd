extends RigidBody2D
@export var updateRate : float
var remainingUpdateTime : float = updateRate
@onready var target_pos : Vector2 = position
@export var acceleration : float 
@export var friction : float 
func _physics_process(delta: float) -> void:
	_tick_update(delta)
	_move()
func _tick_update(d):
	remainingUpdateTime -= d
	if remainingUpdateTime <= 0:
		remainingUpdateTime = updateRate
		_update()
	
func _update():
	target_pos = manager_singleton.instance().player.position

func _move():
	var wishDir = (target_pos - position).normalized()
	rotation = linear_velocity.angle()
	linear_velocity += (wishDir * acceleration)
	linear_velocity *= friction
