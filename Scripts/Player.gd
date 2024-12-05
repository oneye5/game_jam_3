class_name  Player
extends CharacterBody2D

@export var acceleration : float
@export var friction : float
@export var reload_time : float = 0.5
@export var shoot_cost : float = 1.0
@onready var children = $"../children"
@onready var animatedSprite = $AnimatedSprite2D
@onready var remaining_reload = reload_time
@onready var joy_meter = $"../Player_UI/joy_meter"
@onready var death_screen = $"../Player_UI/death_screen"


@export var dash_cost = 3
@export var dash_reload_time = 1
@export var dash_duration = 0.1
@export var dash_velocity = 800
@onready var enemy_manager = $"../enemies"
@onready var sound_shoot = $Sounds/shoot
@onready var sound_hurt = $Sounds/hurt
@onready var sound_add_joy = $Sounds/joy_add
@onready var sound_dash = $Sounds/dash
@onready var sound_wave_start = $"Sounds/Level1-[audioTrimmer_com]"
var dash_wishDir : Vector2 = Vector2.ONE
var remaining_dash_duration : float = -1
var remaining_dash_reload : float = 0

var dead : bool = false


var joy : float = 50
var max_joy : float = 100

func _ready():
	manager_singleton.instance().player = self

func damage_player(amount, knockback):
	joy -= amount
	velocity = knockback
	remaining_dash_duration = -1 # to avoid knockback from being overwritten
	sound_hurt.play()
	_tick_die()

func _tick_die():
	if joy < 0:
		death_screen.visible = true
		dead = true

func _tick_reset():
	if Input.is_action_just_pressed("reset"):
		manager_singleton.instance().spawnPoints = []
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
		manager_singleton.instance().damage_level = 0
		manager_singleton.instance().fire_rate_level = 0
		manager_singleton.instance().projectile_level = 0
		manager_singleton.instance().upgrade_half_price_ammo = false
		manager_singleton.instance().upgrade_dash = false
		enemy_manager._clean()


func _process(delta: float) -> void:
	if dead:
		return
	look_at(get_global_mouse_position())
	move_and_slide()
	if max_joy < joy:
		joy = max_joy

func _physics_process(delta: float) -> void:
	_tick_reset()
	if dead:
		return
	_tick_controls()
	_tick_friction()
	_tick_dash(delta)
	var cooldown_bonus = manager_singleton.instance().fire_rate_level/2.0
	remaining_reload -= delta * (1 + cooldown_bonus)

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
		if manager_singleton.instance().upgrade_half_price_ammo:
			joy -= shoot_cost/2.0
		else:
			if joy - shoot_cost > 0:
				joy -= shoot_cost
		remaining_reload = reload_time
		var projectile = preload("res://Scenes/Projectile.tscn")
		var newProjectile = projectile.instantiate()
		newProjectile.position = position
		newProjectile.rotation = rotation
		children.add_child(newProjectile)
		animatedSprite.play("shoot")
		sound_shoot.play()
		
	_tick_accelerate(wishDir)

func _tick_friction():
	velocity *= friction

func _tick_accelerate(wishDir):
	velocity += (wishDir * acceleration)
	
func _tick_animation():
	if(animatedSprite.animation == "shoot" and not animatedSprite.is_playing()):
		animatedSprite.play("default")

func add_joy(amount):
	show_floating_text("+" + str(amount) + "joy",1,Vector2.ONE*200,30,joy_meter.get_parent())
	joy += amount
	sound_add_joy.play()

func _tick_dash(delta):
	if not manager_singleton.instance().upgrade_dash:
		return 
		
	remaining_dash_reload -= delta
	if remaining_dash_duration >= 0:
		remaining_dash_duration -= delta
		remaining_dash_reload = dash_reload_time
		velocity = dash_wishDir * dash_velocity
	
	if Input.is_action_just_pressed("dash") and remaining_dash_reload <= 0:
		remaining_dash_duration = dash_duration
		remaining_dash_reload = dash_reload_time
		dash_wishDir = (global_position - get_global_mouse_position()).normalized() * -1.0 
		sound_dash.play()
		if joy - dash_cost > 1:
			joy -= dash_cost
		
func show_floating_text(text: String, duration: float, position_range: Vector2, rotation_range: float, parent_node: Node): 
	var label = Label.new() 
	parent_node.add_child(label)
	
	# Set text and style
	label.text = text
	if(duration < 0):
		label.set("theme_override_font_sizes/font_size", 60) 
	else:
		label.set("theme_override_font_sizes/font_size", 40) 
	
	# Set random position within range
	var random_x = randf_range(-position_range.x / 2, position_range.x / 2)
	var random_y = randf_range(-position_range.y / 2, position_range.y / 2)
	var viewport_size = Vector2(get_viewport().size)
	var screen_center = viewport_size / 2
	
	random_x -= 150 #to adjust for text lenght, theres a better way of doing this im just lazy ;)
	
	if(duration < 0):
		random_y += 150
		random_x -= 400
	
	label.position = screen_center #+ Vector2(random_x, random_y)
	
	# Set random rotation
	label.rotation_degrees = randf_range(-rotation_range / 2, rotation_range / 2)
	if(duration >= 0):
	# Create and start tween for scaling
		var tween = create_tween()
		tween.tween_property(label, "scale", Vector2.ZERO, duration)
	
		# Set up timer for cleanup
		await get_tree().create_timer(duration).timeout
		label.queue_free()
