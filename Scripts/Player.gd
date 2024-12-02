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

func damage_player(amount, knockback):
	joy -= amount
	velocity = knockback

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	move_and_slide()

func _physics_process(delta: float) -> void:
	_tick_controls()
	_tick_friction()
	_tick_UI()
	var cooldown_bonus = manager_singleton.instance().fire_rate_level/2.0
	remaining_reload -= delta * (1 + cooldown_bonus)

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

func add_joy(amount):
	show_floating_text("+" + str(amount) + "joy",3,Vector2.ONE*3,30,joy_meter.get_parent())
	joy += amount

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
