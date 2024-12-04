class_name Enemy_0
extends CharacterBody2D

@export var updateRate : float
@onready var target_pos : Vector2 = global_position
@export var acceleration : float 
@export var friction : float 
@export var max_health : float = 100
@export var reload_time : float
@onready var current_health = max_health
@onready var healthbar = $"../mover/ProgressBar"
@onready var remaining_reload : float = reload_time
@onready var attack_hitbox = $attack_hitbox
@export var damage = 5
@export var knockback = 200
@export var enraged_boost : float = 2

var remainingUpdateTime : float = updateRate


func _process(delta: float) -> void:
	move_and_slide()

func _physics_process(delta: float) -> void:
	_tick_update(delta)
	_move()
	_tick_die()
	remaining_reload -= delta

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
	velocity *= 0.2
	current_health -= num
	

func _tick_update(d):
	remainingUpdateTime -= d
	if remainingUpdateTime <= 0:
		remainingUpdateTime = updateRate
		_update()
	
func _update():
	target_pos = manager_singleton.instance().player.global_position

func _move():
	var d = global_position - target_pos
	var dist_to_wish = sqrt((d.x * d.x) + (d.y * d.y))
	if dist_to_wish < 50:
		_update()
	
	var wishDir = (target_pos - global_position).normalized()
	rotation = velocity.angle()
	velocity += (wishDir * acceleration)
	velocity *= friction

func body_entered_attack_hitbox(body):
	if remaining_reload > 0: 
		return
	
	if body is Player:
		body.damage_player(damage, Vector2.from_angle(rotation) * knockback)
		remaining_reload = reload_time
		var preloadAttack = preload("res://Scenes/enemy_attack_0.tscn")
		var attack = preloadAttack.instantiate()
		
		self.add_child(attack)
		
