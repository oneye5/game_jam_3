extends RigidBody2D
@export var acceleration : float
@export var friction : float
@onready var children = $"../children"
@onready var animatedSprite = $AnimatedSprite2D
	

func _physics_process(delta: float) -> void:
	_tick_controls()
	_tick_friction()
	
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
	if Input.is_action_pressed("shoot"):
		var projectile = preload("res://Scenes/Projectile.tscn")
		var newProjectile = projectile.instantiate()
		newProjectile.position = position
		newProjectile.rotation = rotation
		children.add_child(newProjectile)
		animatedSprite.play("shoot")
		
	_tick_accelerate(wishDir)
	look_at(get_global_mouse_position())
	
func _tick_friction():
	linear_velocity *= friction

func _tick_accelerate(wishDir):
	linear_velocity += (wishDir * acceleration)
func _tick_animation():
	if(animatedSprite.animation == "shoot" and not animatedSprite.is_playing()):
		animatedSprite.play("default")
