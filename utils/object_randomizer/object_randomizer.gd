extends Node

class_name ObjectRandomizer

var allObjects: Array

var levelUpMenu



func initialize() -> void:
	allObjects.append(preload("res://entitys/weapons/arrowWeapon/arrowWeapon.tscn").instantiate())
	allObjects.append(preload("res://entitys/weapons/magicArea/magic_area.tscn").instantiate())
	allObjects.append(preload("res://entitys/weapons/shurikenWeapon/shuriken_weapon.tscn").instantiate())
	allObjects.append(preload("res://entitys/items/VelocityMovementBuff/VelocityMovementBuff.tscn").instantiate())
	allObjects.append(preload("res://entitys/items/HealthBuff/HealthBuff.tscn").instantiate())
	allObjects.append(preload("res://entitys/items/ExperienceMultBuff/ExperienceBuff.tscn").instantiate())
	allObjects.append(preload("res://entitys/items/DamageMultBuff/DamageMultBuff.tscn").instantiate())
	allObjects.append(preload("res://entitys/items/AttackCooldownBuff/AttackCooldownBuff.tscn").instantiate())
	print(allObjects.size() , "asdssa")
	
func chooseRandomObjects(amount: int):
	var objectsChoosen: Array 

	var pool := allObjects.duplicate()
	pool.shuffle()

	var amount_to_choose = min(amount, pool.size())  # Evitar errores si hay menos de 3

	for i in amount_to_choose:
		objectsChoosen.append(pool[i])
	
	return objectsChoosen
