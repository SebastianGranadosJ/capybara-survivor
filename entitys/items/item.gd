extends Node2D

class_name Item 

var level: int
var objectName: String
var id:String

func _init() -> void:
	level = 1
	objectName = "Undifined"
	id = "I000"
	
func level_up():
	assert(false, "La función 'attack()' debe ser sobreescrita por una subclase")

func get_buff_for_level(target_level:int):
	assert(false, "La función 'get_buff_for_level()' debe ser sobreescrita por una subclase")	
	
func apply_effect(body):
	assert(false, "La función 'attack()' debe ser sobreescrita por una subclase")

func get_level_up_message():
	assert(false, "La función 'get_level_up_message()' debe ser sobreescrita por una subclase")

func get_description():
	return objectName
