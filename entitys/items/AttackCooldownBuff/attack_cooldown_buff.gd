extends Item

var attackCooldownBuff: float

func _init():
	objectName = "Velocity Attack Buff"
	level = 1
	attackCooldownBuff =  get_buff_for_level(level)
	id = "I005"
	
func level_up():
	level += 1
	attackCooldownBuff = get_buff_for_level(level)
	

func get_buff_for_level(target_level:int):
	match target_level:
		1: return 0.3
		2: return 0.5
		3: return 0.6
		4: return 0.7
		5: return 0.8
		_: return get_buff_for_level(5) + (target_level - 5) * 0.03

func apply_effect(body):
	for weapon in body.weapons:
		weapon.set_attack_cooldown(weapon.baseAttackCooldown - weapon.baseAttackCooldown*attackCooldownBuff)
	return false
				
func get_level_up_message() -> String:
	var current_buff = get_buff_for_level(level)
	var next_buff = get_buff_for_level(level + 1)
	return "Attack Cooldown Buff sube de nivel %d a %d: Cooldown de las armas reducido de x%.2f a x%.2f" % [level, level + 1, current_buff, next_buff]

func get_description() -> String:
	var base_buff = get_buff_for_level(1)
	return "Reduce el Cooldown de las armas. En nivel 1 lo reduce en un x%.2f." % base_buff
