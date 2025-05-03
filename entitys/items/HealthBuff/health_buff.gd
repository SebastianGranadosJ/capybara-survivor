extends Item

var health_buff: float

func _init():
	objectName = "Health Buff"
	level = 1
	health_buff = 10
	id = "I002"
	
func level_up():
	level += 1
	health_buff = get_buff_for_level(level)

func get_buff_for_level(target_level:int):
	match target_level:
		1: return 50
		2: return 100
		3: return 200
		4: return 400
		5: return 800
		_: return get_buff_for_level(5) + (target_level - 5) * 10

func apply_effect(body):
	if "maxHealth" in body and "BASEMAXHEALTH" in body:
		body.maxHealth = body.BASEMAXHEALTH + health_buff
		if body.health + health_buff <= body.maxHealth:
			body.health = body.health + health_buff
		else:
			body.health = body.maxHealth
	body.reloadProgressBarHealth()

func get_level_up_message() -> String:
	var current_buff = get_buff_for_level(level)
	var next_buff = get_buff_for_level(level + 1)
	return "Health Buff sube de nivel %d a %d: Salud aumenta de +%.0f a +%.0f" % [level, level + 1, current_buff, next_buff]

func get_description() -> String:
	var base_buff = get_buff_for_level(1)
	return "Aumenta la salud máxima del personaje. En nivel 1 proporciona un bono de +%.0f puntos de salud." % base_buff
