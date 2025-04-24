extends Control

var objectRandomizer
var objectsChoosen
var player

func _ready():
	objectRandomizer = preload("res://utils/object_randomizer/object_randomizer.gd").new()
	
func initialize(body):
	paused()
	player = body
	objectRandomizer.initialize()
	objectsChoosen = objectRandomizer.chooseRandomObjects(3)
	print(objectsChoosen)
	display_object_info(%ButtonItem1,objectsChoosen[0] )
	display_object_info(%ButtonItem2,objectsChoosen[1] )
	display_object_info(%ButtonItem3,objectsChoosen[2] )


func resume():
	get_tree().paused = false
	

func paused():
	get_tree().paused = true

func display_object_info(button: Button, object):
	var player_object = player.has_object_with_id(object.id)
	
	if player_object == null:
		button.text = object.get_description()
	else:
		button.text = player_object.get_level_up_message()
	
	
func _on_button_item_1_pressed() -> void:
	player.level_up(objectsChoosen[0])
	resume()
	close_menu()
	

func _on_button_item_2_pressed() -> void:
	player.level_up(objectsChoosen[1])
	resume()
	close_menu()

func _on_button_item_3_pressed() -> void:
	player.level_up(objectsChoosen[2])
	resume()
	close_menu()


func close_menu():
	player.isLevelUpMenuActive = false
	resume()
	queue_free()

	# Si hay más menús en la cola, mostrar el siguiente
	if player.levelUpMenuQueue.size() > 0:
		player.levelUpMenuQueue.pop_front()
		player.show_level_up_menu()
