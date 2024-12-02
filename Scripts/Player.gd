class_name  Player
extends CharacterBody2D
@export var acceleration : float
@export var friction : float
@export var reload_time : float = 0.5
@onready var children = $"../children"
@onready var animatedSprite = $AnimatedSprite2D
@onready var remaining_reload = reload_time
@onready var joy_meter = $"../Player_UI/joy_meter"

var joy : float = 50


func _ready():
	manager_singleton.instance().player = self
	
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	move_and_slide()

func _physics_process(delta: float) -> void:
	_tick_controls()
	_tick_friction()
	_tick_UI()
	print(velocity)
	print(position)
	remaining_reload -= delta
	

func eat_food(amount):
	joy += amount

func _tick_UI():
	joy_meter.value = joy

func _tick_controls():
	var wishDir : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("up"):
		wishDir.y -= 1
	if Input.is_action_pressed("down"):
		wishDir.y += 1
	if Input.is_action_pressed("right"):
		wishDir.x += 1
	if Input.is_action_pressed("left"):
		wishDir.x -= 1
	if Input.is_action_pressed("shoot") and remaining_reload <= 0:
		remaining_reload = reload_time
		var projectile = preload("res://Scenes/Projectile.tscn")
		var newProjectile = projectile.instantiate()
		newProjectile.position = position
		newProjectile.rotation = rotation
		children.add_child(newProjectile)
		animatedSprite.play("shoot")
		
	_tick_accelerate(wishDir)

func _tick_friction():
	velocity *= friction

func _tick_accelerate(wishDir):
	velocity += (wishDir * acceleration)
	
func _tick_animation():
	if(animatedSprite.animation == "shoot" and not animatedSprite.is_playing()):
		animatedSprite.play("default")
