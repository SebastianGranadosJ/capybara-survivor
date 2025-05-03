extends Area2D

var travelled_distance = 0
var damage = 1
var shoot_direction := Vector2.RIGHT



func initialize(damage := 1.0, angle := 0.0):
	self.damage = damage
	shoot_direction = Vector2.RIGHT.rotated(angle)
	rotation = angle  # Esto también ajusta visualmente el sprite, si lo deseas

func _physics_process(delta):
	const SPEED = 450
	const RANGE = 1200
	const ROTATION_SPEED = 5.0  # Radianes por segundo (ajusta según lo que necesites)
	
	position += shoot_direction * SPEED * delta
	travelled_distance += SPEED * delta

	rotation += ROTATION_SPEED * delta  # ← Esta línea hace que rote continuamente

	%AnimationPlayer2.play("ataque")
	
	if travelled_distance > RANGE:
		queue_free()
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	var push_direction = (body.global_position - global_position).normalized()
	var push_strength = 1000

	if body.has_method("apply_knockback"):
		body.apply_knockback(push_direction, push_strength)
