class_name Enemy_3
extends CharacterBody2D

@onready var target_pos : Vector2 = global_position
@export var acceleration : float 
@export var friction : float 
@export var max_health : float = 100
@export var reload_time : float
@onready var current_health = max_health
@onready var healthbar = $"../mover/ProgressBar"
@onready var remaining_reload : float = reload_time
@onready var sound_shoot = $shoot_sound
@export var enraged_boost : float = 2

@export var min_range : float
@export var max_range : float
@export var max_vel : float

@export var rotation_lerp = 0.01
@export var acceptable_aim_error = 0.5
@export var predict_factor = 1000.0

func _process(delta: float) -> void:
	move_and_slide()

func _physics_process(delta: float) -> void:
	_tick_update(delta)
	_tick_die()
	remaining_reload -= delta

func _tick_update(delta):
	velocity *= friction
	remaining_reload -= delta
	var delta_p = global_position - manager_singleton.instance().player.global_position
	var d = sqrt((delta_p.x*delta_p.x) + (delta_p.y * delta_p.y))
	if d > min_range and d < max_range:
		aim()
		if max_vel > velocity.x and max_vel > velocity.y and remaining_reload <= 0:
			aim_and_fire()
		return
	
	# move
	var wishDir = delta_p.normalized()
	if d > min_range: # run away
		wishDir *= -1
	rotation = velocity.angle()
	velocity += wishDir * acceleration

func get_desired_rotation():
	var delta = global_position - manager_singleton.instance().player.global_position
	var dist = sqrt((delta.x*delta.x) + (delta.y*delta.y))
	var predict_time = dist * predict_factor
	var predicted_pos = manager_singleton.instance().player.velocity * predict_time + manager_singleton.instance().player.global_position
	delta = predicted_pos - global_position 
	return  delta.normalized().angle() 
	

func aim():
	var desired_rotation = get_desired_rotation()
	rotation = lerp(rotation, desired_rotation, rotation_lerp)
	

func aim_and_fire():
	aim()
	var desired_rotation = get_desired_rotation()
	if  abs(desired_rotation - rotation) < acceptable_aim_error:
		_shoot()

func get_fire_offset(angle):
	return Vector2.from_angle(angle+90) * 25 + Vector2.from_angle(angle) * 20

func _shoot():
	var proj_pre = preload("res://Scenes/Enemy_projectile.tscn")
	var proj = proj_pre.instantiate()
	proj.global_position = global_position
	proj.rotation = rotation 
	
	proj.global_position += get_fire_offset(rotation)
	sound_shoot.play()
	get_parent().get_parent().add_child(proj)
	remaining_reload = reload_time

func _tick_die():
	healthbar.value =  (1 - (current_health/max_health)) * 100
	if current_health <= 0:
		var preLoadCookie = preload("res://Scenes/Food_pickup.tscn")
		var cookie = preLoadCookie.instantiate()
		cookie.global_position = global_position
		cookie.rotation = 0
		self.get_parent().get_parent().add_child(cookie)
		self.get_parent().queue_free()

func _damage(num):
	velocity *= 0.01
	current_health -= num
