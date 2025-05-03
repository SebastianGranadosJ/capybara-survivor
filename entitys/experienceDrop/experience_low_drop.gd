extends Node2D

var exp = [1 , 2, 2, 2, 2, 2, 2, 3, 3 , 10 ]


	
func _physics_process(delta: float) -> void:
	%xp.play()

func _on_area_2d_body_entered(body):
	if body.has_method("take_exp"):
		exp.shuffle()
		body.take_exp(exp[0])
		queue_free() 
	
