extends Node2D
func _ready() -> void:
	manager_singleton.instance().spawnPoints.append(self)
