class_name Enemy_0
extends CharacterBody2D

@export var updateRate : float
var remainingUpdateTime : float = updateRate
@onready var target_pos : Vector2 = position
@export var acceleration : float 
@export var friction : float 
@export var max_health : float = 100
@onready var current_health = max_health
@onready var healthbar = $ProgressBar
func _process(delta: float) -> void:
	move_and_slide()

func _physics_process(delta: float) -> void:
	_tick_update(delta)
	_move()
	healthbar.value = current_health
	if current_health <= 0:
		var preLoadCookie = preload("res://Scenes/Food_pickup.tscn")
		var cookie = preLoadCookie.instantiate()
		cookie.position = position
		cookie.rotation = 0
		self.get_parent().add_child(cookie)
		queue_free()

func _damage(num):
	velocity = Vector2.ZERO
	current_health -= num
	

func _tick_update(d):
	remainingUpdateTime -= d
	if remainingUpdateTime <= 0:
		remainingUpdateTime = updateRate
		_update()
	
func _update():
	target_pos = manager_singleton.instance().player.position

func _move():
	var wishDir = (target_pos - position).normalized()
	rotation = velocity.angle()
	velocity += (wishDir * acceleration)
	velocity *= friction
