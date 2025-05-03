extends Weapon






func _init():
	baseAttackCooldown = 1.0
	objectName = "Magia Cabrona"
	attackCooldown = baseAttackCooldown
	sizeMultiplier = 1.0
	criticalRatio = 0.0
	level = 1
	damage = get_buff_for_level(level)
	id = "W002"
	
func _physics_process(delta: float) -> void:
		%Animation.play()


func attack():

	print("xads")
	var enemies_in_range = %MagicArea2D.get_overlapping_bodies()
	for enemy in enemies_in_range:
		if enemy.has_method("take_damage"):
			enemy.take_damage(calculateAttackDamage())

func level_up():
	level += 1
	damage = get_buff_for_level(level)
	

func get_buff_for_level(target_level:int):
	match target_level:
		1: return 2
		2: return 6
		3: return 10
		4: return 25
		5: return 40
		_: return get_buff_for_level(5) + (target_level - 5) * 20


func get_level_up_message() -> String:
	var current_buff = get_buff_for_level(level)
	var next_buff = get_buff_for_level(level + 1)
	return "%s: sube de nivel %d a %d: Daño aumenta de %d a %d" % [objectName, level, level + 1, current_buff, next_buff]


func get_description() -> String:
	return "Genera un area cabrona magica alrededor tuyo que daña a los enemigos"
