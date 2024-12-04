extends Button
@export var type : int = 0

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
	if type == 0:
		var cost = manager_singleton.instance().base_upgrade_cost * (manager_singleton.instance().damage_level + 1)
		text = "Upgrade present joy\n-" + str(cost) + " joy"
	if type == 1:
		var cost = manager_singleton.instance().base_upgrade_cost * (manager_singleton.instance().fire_rate_level + 1)
		text = "Upgrade fire-rate\n-" + str(cost) + " joy"
	if type == 2:
		var cost = manager_singleton.instance().base_upgrade_cost * (manager_singleton.instance().projectile_level + 1)
		text = "Upgrade projectile-speed\n-" + str(cost) + " joy"
	if type == 3:
		if manager_singleton.instance().upgrade_half_price_ammo:
			text = "Half price presents is already owned"
		else:
			text = "Half price presents\n-" + str(manager_singleton.instance().upgrade_half_price_ammo_cost) + " joy"
	if type == 4:
		if manager_singleton.instance().upgrade_dash:
			text = "Joy dash is unlocked\nEvery dash costs -" + str(manager_singleton.instance().player.dash_cost) + " joy"
		else:
			text = "Unlock Joy dash\n-" + str(manager_singleton.instance().upgrade_dash_cost) + " joy"
	
func _pressed():
	if type == 0:
		var cost = manager_singleton.instance().base_upgrade_cost * (manager_singleton.instance().damage_level + 1)
		if cost > manager_singleton.instance().player.joy:
			return
		manager_singleton.instance().player.joy -= cost
		manager_singleton.instance().damage_level += 1
	if type == 1:
		var cost = manager_singleton.instance().base_upgrade_cost * (manager_singleton.instance().fire_rate_level + 1)
		if cost > manager_singleton.instance().player.joy:
			return
		manager_singleton.instance().player.joy -= cost
		manager_singleton.instance().fire_rate_level += 1
	if type == 2:
		var cost = manager_singleton.instance().base_upgrade_cost * (manager_singleton.instance().projectile_level + 1)
		if cost > manager_singleton.instance().player.joy:
			return
		manager_singleton.instance().player.joy -= cost
		manager_singleton.instance().projectile_level += 1
	if type == 3:
		if manager_singleton.instance().upgrade_half_price_ammo:
			return
		var cost = manager_singleton.instance().upgrade_half_price_ammo_cost
		if cost > manager_singleton.instance().player.joy:
			return
		manager_singleton.instance().player.joy -= cost
		manager_singleton.instance().upgrade_half_price_ammo = true
	if type == 4:
		if manager_singleton.instance().upgrade_dash:
			return
		var cost = manager_singleton.instance().upgrade_dash_cost
		if cost > manager_singleton.instance().player.joy:
			return
		manager_singleton.instance().player.joy -= cost
		manager_singleton.instance().upgrade_dash = true
	
