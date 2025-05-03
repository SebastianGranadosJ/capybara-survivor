extends Weapon


var alternate_shooting := false  # Inicialmente dispara derecha–izquierda


func _init():
	baseAttackCooldown = 4
	objectName = "Shurikens Cabrones"
	damage = get_buff_for_level(level)
	attackCooldown = baseAttackCooldown
	sizeMultiplier = 1.0
	criticalRatio = 0.0
	level = 1
	id = "W003"



func attack():
	const SHUR = preload("res://entitys/weapons/shurikenWeapon/shuriken/shuriken.tscn")
	
	var new_shur_1 = SHUR.instantiate()
	var new_shur_2 = SHUR.instantiate()
	var offset_distance = 20

	if alternate_shooting:
		# Disparo ARRIBA y ABAJO
		var rotation_up = global_rotation - deg_to_rad(90)
		var rotation_down = global_rotation + deg_to_rad(90)

		var direction_up = Vector2.RIGHT.rotated(rotation_up)
		var direction_down = Vector2.RIGHT.rotated(rotation_down)

		new_shur_1.global_position = global_position + direction_up * offset_distance
		new_shur_1.initialize(calculateAttackDamage(), rotation_up)

		new_shur_2.global_position = global_position + direction_down * offset_distance
		new_shur_2.initialize(calculateAttackDamage(), rotation_down)
	else:
		# Disparo DERECHA e IZQUIERDA
		var rotation_right = global_rotation
		var rotation_left = global_rotation + deg_to_rad(180)

		var direction_right = Vector2.RIGHT.rotated(rotation_right)
		var direction_left = Vector2.RIGHT.rotated(rotation_left)

		new_shur_1.global_position = global_position + direction_right * offset_distance
		new_shur_1.initialize(calculateAttackDamage(), rotation_right)

		new_shur_2.global_position = global_position + direction_left * offset_distance
		new_shur_2.initialize(calculateAttackDamage(), rotation_left)

	add_child(new_shur_1)
	add_child(new_shur_2)

	# Cambiar para el próximo ataque
	alternate_shooting = !alternate_shooting


func level_up():
	level += 1
	damage = get_buff_for_level(level)
	

func get_buff_for_level(target_level:int):
	match target_level:
		1: return 10
		2: return 25
		3: return 45
		4: return 70
		5: return 110
		_: return get_buff_for_level(5) + (target_level - 5) * 20


func get_level_up_message() -> String:
	var current_buff = get_buff_for_level(level)
	var next_buff = get_buff_for_level(level + 1)
	return "%s: sube de nivel %d a %d: Daño aumenta de %d a %d" % [objectName, level, level + 1, current_buff, next_buff]


func get_description() -> String:
	return "Dispara shurikens cabrones de manera vertical y horizontal que pueden empujar a los enemigos"
