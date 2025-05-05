extends Weapon

func _init():
	baseAttackCooldown = 0.5
	objectName = "Bolas Cabronas"
	attackCooldown = baseAttackCooldown
	sizeMultiplier = 1.0
	criticalRatio = 0.0
	level = 1
	damage = get_buff_for_level(level)
	
	
	id = "W001"

func _physics_process(delta):
	 # Find all Nodes that are in the Area
	var enemies_in_range = %Area.get_overlapping_bodies()
	
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func attack():
	print("xs")
	const ARROW = preload("res://entitys/weapons/arrowWeapon/arrow/arrow.tscn")
	var new_arrow = ARROW.instantiate()
	new_arrow.initialize(calculateAttackDamage())
	
	var offset_distance = 50  
	
	var direction = Vector2.RIGHT.rotated(global_rotation)
	
	new_arrow.global_position = global_position + direction * offset_distance
	
	new_arrow.global_rotation = global_rotation
	add_child(new_arrow)
	
func level_up():
	level += 1
	damage = get_buff_for_level(level)
	


func get_buff_for_level(target_level:int):
	match target_level:
		1: return 1
		2: return 5
		3: return 12
		4: return 22
		5: return 38
		_: return get_buff_for_level(5) + (target_level - 5) * 5


func get_level_up_message() -> String:
	var current_buff = get_buff_for_level(level)
	var next_buff = get_buff_for_level(level + 1)
	return "%s: sube de nivel %d a %d: Daño aumenta de %d a %d" % [objectName, level, level + 1, current_buff, next_buff]


	
func get_description() -> String:
	return "Dispara flechas cabronas a los enemigos"
