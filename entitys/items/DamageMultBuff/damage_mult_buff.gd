extends Item

var damageMultBuff: float

func _init():
	objectName = "Damage Multiplier Buff"
	level = 1
	damageMultBuff =  get_buff_for_level(level)
	id = "I004"
	
func level_up():
	level += 1
	damageMultBuff = get_buff_for_level(level)

func get_buff_for_level(target_level:int):
	match target_level:
		1: return 1.4
		2: return 1.8
		3: return 2.3
		4: return 3
		5: return 3.6
		_: return get_buff_for_level(5) + (target_level - 5) * 0.03

func apply_effect(body):
	if "damageMult" in body:
		body.damageMult = damageMultBuff

func get_level_up_message() -> String:
	var current_buff = get_buff_for_level(level)
	var next_buff = get_buff_for_level(level + 1)
	return "Damage Multiplier Buff sube de nivel %d a %d: Multiplicador de daño aumenta de x%.2f a x%.2f" % [level, level + 1, current_buff, next_buff]

func get_description() -> String:
	var base_buff = get_buff_for_level(1)
	return "El objeto 'Damage Multiplier Buff' aumenta el daño del jugador. En el nivel 1 otorga un multiplicador de daño de x%.2f." % base_buff
