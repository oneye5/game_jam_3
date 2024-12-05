extends Node

var wave_number = 0
@export var wave_break_time = 5.0
@export var wave_enemies : Array[int]
@export var wave_reload_time : Array[float]
@export var wave_max_living : Array[int]
@export var wave_enemy_count : Array[int]
var wave_started : bool = false
var remaining_spawn_reload = 3.0
var enemies : Array = []

var current_enemy_count = 0
@onready var remaining_wave_break = wave_break_time

func _clean():
	enemies = enemies.filter(func(enemy): return is_instance_valid(enemy))

func _physics_process(delta: float) -> void:
	_clean()
	
	if not wave_started:
		remaining_wave_break -= delta
		if remaining_wave_break <= 0:
			wave_started = true
			remaining_wave_break = wave_break_time
			manager_singleton.instance().player.sound_wave_start.play()
			manager_singleton.instance().player.show_floating_text("Wave " + str(wave_number + 1) + " begins!", 3, Vector2.ZERO, 15, manager_singleton.instance().player.joy_meter.get_parent())
	else: 
		remaining_spawn_reload -= delta

	
	if enemies.size() < wave_max_living[wave_number] and remaining_spawn_reload < 0 and wave_started:
		if wave_enemy_count[wave_number] == current_enemy_count:
			if enemies.size() == 0: 
				wave_number += 1
				wave_started = false
				manager_singleton.instance().player.show_floating_text("Wave " + str(wave_number) + " complete", 3, Vector2.ZERO, 15, manager_singleton.instance().player.joy_meter.get_parent())
				remaining_wave_break = wave_break_time
			return 
		var spawnPoint = _get_spawnpoint()
		var preloaded
		if wave_enemies[current_enemy_count] == 0:
			preloaded = preload("res://Scenes/Enemy_0.tscn")
		if wave_enemies[current_enemy_count] == 1:
			preloaded = preload("res://Scenes/Enemy_1.tscn")
		if wave_enemies[current_enemy_count] == 2:
			preloaded = preload("res://Scenes/Enemy_2.tscn")
		if wave_enemies[current_enemy_count] == 3:
			preloaded = preload("res://Scenes/Enemy_3.tscn")
		if wave_enemies[current_enemy_count] == 10:
			preloaded = preload("res://Scenes/Enemy_0_2.tscn")
		if wave_enemies[current_enemy_count] == 11:
			preloaded = preload("res://Scenes/Enemy_1_2.tscn")
		if wave_enemies[current_enemy_count] == 12:
			preloaded = preload("res://Scenes/Enemy_2_2.tscn")
		if wave_enemies[current_enemy_count] == 13:
			preloaded = preload("res://Scenes/Enemy_3_2.tscn")
		# further types
		
		
		var enemy = preloaded.instantiate()
		enemy.position = spawnPoint
		add_child(enemy)
		remaining_spawn_reload = wave_reload_time[wave_number]
		current_enemy_count += 1
		enemies.append(enemy)
	
		
func _get_spawnpoint() -> Vector2:
	var pos : Vector2
	_clean()
	while(true):
		var index = round(randf() * (manager_singleton.instance().spawnPoints.size()-1))
		pos = manager_singleton.instance().spawnPoints[index].global_position
		var d = pos - manager_singleton.instance().player.global_position
		var dist_to_player = sqrt((d.x*d.x) + (d.y * d.y))
		print(dist_to_player)
		if dist_to_player > 500:
			return pos
	return pos
