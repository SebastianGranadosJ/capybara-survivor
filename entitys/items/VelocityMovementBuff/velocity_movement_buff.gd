extends Item

var velocityMovementBuff: float

func _init():
	objectName = "Velocity Movement Buff"
	level = 1
	velocityMovementBuff =  get_buff_for_level(level)
	id = "I001"
	
func level_up():
	level += 1
	velocityMovementBuff = get_buff_for_level(level)
	

func get_buff_for_level(target_level:int):
	match target_level:
		1: return 1.2
		2: return 1.25
		3: return 1.32
		4: return 1.4
		5: return 1.5
		_: return get_buff_for_level(5) + (target_level - 5) * 0.03

func apply_effect(body):
	
	body.moveVel = body.BASEMOVEVEL  * velocityMovementBuff
	
				
func get_level_up_message() -> String:
	var current_buff = get_buff_for_level(level)
	var next_buff = get_buff_for_level(level + 1)
	return "Velocity Movement Buff sube de nivel %d a %d: Velocidad aumenta de x%.2f a x%.2f" % [level, level + 1, current_buff, next_buff]

func get_description() -> String:
	var base_buff = get_buff_for_level(1)
	return "Aumenta la velocidad de movimiento del personaje. En nivel 1 incrementa la velocidad en un x%.2f." % base_buff
