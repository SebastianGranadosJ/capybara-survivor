extends Item

var experienceMultBuff: float


func _init():
	objectName = "Experience Multiplier Buff"
	level = 1
	experienceMultBuff = get_buff_for_level(level)
	id = "I003"
		
func level_up():
	level += 1
	experienceMultBuff = get_buff_for_level(level)

func get_buff_for_level(target_level:int):
	match target_level:
		1: return 1.5
		2: return 2
		3: return 2.8
		4: return 3.5
		5: return 5
		_: return get_buff_for_level(5) + (target_level - 5) * 0.03

func apply_effect(body):
	if "expMult" in body:
		body.expMult = experienceMultBuff
		
func get_level_up_message() -> String:
	var current_buff = get_buff_for_level(level)
	var next_buff = get_buff_for_level(level + 1)
	return "Experience Multiplier Buff sube de nivel %d a %d: Multiplicador de experiencia aumenta de x%.2f a x%.2f" % [level, level + 1, current_buff, next_buff]

func get_description() -> String:
	var base_buff = get_buff_for_level(1)
	return "Aumenta la cantidad de experiencia obtenida. En nivel 1 proporciona un multiplicador de experiencia de x%.2f." % base_buff
