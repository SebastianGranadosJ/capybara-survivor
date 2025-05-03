extends Control


func _on_button_pressed() -> void:
	get_tree().paused = false
	print("Presed")
	
	get_tree().reload_current_scene() # Replace with function body.
	self.queue_free()
