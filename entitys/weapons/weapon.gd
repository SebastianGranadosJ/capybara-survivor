extends Node2D
class_name Weapon

var baseAttackCooldown = 1.0
var id:String
var attack_cooldown_timer: Timer
var objectName: String 
var damage: float 
var attackCooldown
var sizeMultiplier
var criticalRatio
var level: int

func _init():
	objectName = "Shuriken Cabron"
	damage = 1.0
	attackCooldown = baseAttackCooldown
	sizeMultiplier = 1.0
	criticalRatio = 0.0
	level = 1
	id = "W000"
	


func _ready():
	# Crear e inicializar el timer en _ready, cuando el nodo ya forma parte del árbol
	attack_cooldown_timer = Timer.new()
	attack_cooldown_timer.wait_time = attackCooldown
	attack_cooldown_timer.one_shot = false
	attack_cooldown_timer.autostart = true
	add_child(attack_cooldown_timer)
	attack_cooldown_timer.timeout.connect(_on_timer_timeout)

	attack_cooldown_timer.start()


func attack():
	assert(false, "La función 'attack()' debe ser sobreescrita por una subclase")
	
func level_up():
	assert(false, "La función 'attack()' debe ser sobreescrita por una subclase")

func get_buff_for_level(target_level:int):
	assert(false, "La función 'get_buff_for_level()' debe ser sobreescrita por una subclase")	



func get_level_up_message() -> String:
	return "Arma sube de nivel %d a %d" % [level, level + 1]

func get_description() -> String:
	return "Descripcion Arma"



func calculateAttackDamage():
	if get_parent().has_method("getDmgMutiplier"):
		return damage * get_parent().getDmgMutiplier()
	return damage


func calculateCriticalRatio():
	if get_parent().has_method("getCriticalRatio"):
		return criticalRatio + get_parent().getCriticalRatio()
	return criticalRatio


func _on_timer_timeout():
	attack()


func set_attack_cooldown(value):
	attackCooldown = value
	attack_cooldown_timer.wait_time = value
	
