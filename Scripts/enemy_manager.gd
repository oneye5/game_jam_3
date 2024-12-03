extends Node

var wave_number = 0
@export var wave_enemies : Array[int]
@export var wave_reload_time : Array[float]
@export var wave_max_living : Array[int]
@export var wave_enemy_count : Array[int]
var wave_started : bool = false
var remaining_spawn_reload = 3.0
var enemies : Array = []

var current_enemy_count = 0

func _ready():
	var x = preload("res://Scenes/Enemy_0.tscn")
	var xx = x.instantiate()
	add_child(xx)
	enemies.append(xx)
	

func _physics_process(delta: float) -> void:
	for enemy in enemies:
		if enemy == null:
			enemies.erase(enemy)
	
	remaining_spawn_reload -= delta
	if enemies.size() < wave_max_living[wave_number] and remaining_spawn_reload < 0:
		var spawnPoint = _get_spawnpoint()
		var preloaded
		if wave_enemies[current_enemy_count] == 0:
			preloaded = preload("res://Scenes/Enemy_0.tscn")
		var enemy = preloaded.instantiate()
		add_child(enemy)
		enemy.position = spawnPoint
		remaining_spawn_reload = wave_reload_time[wave_number]
		# further types
		
func _get_spawnpoint() -> Vector2:
	var index = round(randf() * (manager_singleton.instance().spawnPoints.size()-1))
	print(index)
	var pos_obj : Node2D = manager_singleton.instance().spawnPoints[index]
	return pos_obj.global_position
