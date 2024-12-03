extends Node
class_name manager_singleton
var _instance = null
var player : Player = null 

#player upgrades
var fire_rate_level = 0
var damage_level = 0
var projectile_level = 0
var unique_upgrades = 0 

@export var base_upgrade_cost = 10

static func instance() -> manager_singleton:
	if not Engine.has_singleton("manager_singleton"):
		var singleton = manager_singleton.new()
		Engine.register_singleton("manager_singleton", singleton)
	return Engine.get_singleton("manager_singleton")

func _ready():
	pass


func _get_tree(): # returns the scene tree
	var main_loop = Engine.get_main_loop()
	var tree = main_loop as SceneTree
	return tree
