extends CharacterBody2D

var player
var health = 3
var damage = 1
signal mobKilled
var effects_layer
 	
# Its executed when all have been created
func _ready(): 
	player = get_node("/root/Game/Player")
	effects_layer = get_node("/root/Game/EffectsLayer")
	$Slime.play_walk()	
	
var knockback_velocity := Vector2.ZERO
var knockback_time := 0.2  # tiempo durante el cual se empuja
var knockback_timer := 0.0

func initialize(health: int = 3, damage: int = 1, healtMult: float =1, damageMult: float = 1):
	self.health = health * healtMult
	self.damage = damage * damageMult



func _physics_process(delta):
	if knockback_timer > 0:
		velocity = knockback_velocity
		knockback_timer -= delta
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 150
	move_and_slide()
	$Slime.play_walk()	
	
	 
	
func take_damage(damage = 1):
	
	health -= damage
	if health <= 0:
		mobKilled.emit()
		queue_free()
		
		const EXPERIENCE = preload("res://entitys/experienceDrop/experienceLowDrop.tscn")
		var experience = EXPERIENCE.instantiate()
		effects_layer.add_child(experience)
		experience.global_position = global_position
		
		const SMOKE_SCENE = preload("res://UI/smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		effects_layer.add_child(smoke)
		smoke.global_position = global_position
		player.score += 10 
	
func apply_knockback(direction: Vector2, force: float):
	knockback_velocity = direction.normalized() * force
	knockback_timer = knockback_time
	
	
