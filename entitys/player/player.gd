extends CharacterBody2D

class_name player

signal health_depleted

const BASEMAXHEALTH: float = 50
const BASEMOVEVEL = 350

var score:int = 0
var total_seconds := 0

var maxHealth: float
var health: float 
var level: int
var exp: int
var moveVel: float
var damageMult: float
var expMult: float
var expForNextLevel: int = 10

var weapons: Array[Weapon]

var items: Array[Item]
var idle = true

var levelUpMenu

var levelUpMenuQueue: Array = []
var isLevelUpMenuActive: bool = false

var progressBarHealth

func _ready():
	addWeapon(preload("res://entitys/weapons/arrowWeapon/arrowWeapon.tscn").instantiate())
	levelUpMenu = preload("res://utils/LevelUpMenu/level_up_menu.tscn").instantiate()
	%ProgressBarExperience.max_value = expForNextLevel
	%ProgressBarExperience.value = exp
	progressBarHealth = %ProgressBarHealth
	reloadProgressBarHealth()
	show_object_summary()
	$HappyBoo.play_idle_animation()
	
	
func _init():
	maxHealth = BASEMAXHEALTH
	health  = maxHealth
	level = 1
	exp = 0
	moveVel = BASEMOVEVEL
	damageMult = 1
	expMult = 1
	expForNextLevel = 20
	weapons = []
	items = []
	score =  0
	
	
	
func take_exp(taked_exp: int = 1):
	exp += taked_exp * expMult
	%ProgressBarExperience.value = exp
	
	while exp >= expForNextLevel:
		exp -= expForNextLevel
		show_level_up_menu()


func level_up(node: Node2D):
	 
	expForNextLevel = int(expForNextLevel * 1.3) 
	score += level * 100
	%ProgressBarExperience.max_value = expForNextLevel
	%ProgressBarExperience.value = exp
	level += 1
	reloadLevelLabel()
	health_player()

	# Si el nodo es un 'Weapon'
	if node is Weapon:
		
		# Intentar subir de nivel el arma si ya está en la lista de armas
		if level_up_weapon(node.id):
			show_object_summary()
			return
		# Si no se tiene, agregarla
		addWeapon(node)
		score += 100
		
	# Si el nodo es un 'Item'
	elif node is Item:
		# Intentar subir de nivel el item si ya está en la lista de items
		if level_up_item(node.id):
			show_object_summary()
			return
		# Si no se tiene, agregarlo
		addItem(node)
		
	show_object_summary()

func show_level_up_menu():
	if isLevelUpMenuActive:
		# Si ya hay un menú activo, agregamos uno nuevo a la cola
		levelUpMenuQueue.append(true)  # solo agregamos una marca
		return


	# Si no hay uno activo, mostrarlo ahora
	isLevelUpMenuActive = true
	levelUpMenu = preload("res://utils/LevelUpMenu/level_up_menu.tscn").instantiate()
	get_tree().get_root().add_child(levelUpMenu)
	levelUpMenu.position = global_position
	levelUpMenu.initialize(self)

func addWeapon(weapon: Weapon):

	weapons.append(weapon)

	add_child(weapon)  # Primero agregarlo al árbol
	weapon.position = Vector2(0, -10)  # Luego posicionarlo localmente (respecto al personaje)

func addItem(item:Item):

	items.append(item)
	item.apply_effect(self)

func level_up_item(itemId: String):
	for item in  items:
		if item.id == itemId:
			item.level_up()
			item.apply_effect(self)
			return true
	return false

func level_up_weapon(weapon_id: String):
	for weapon in weapons:
		if weapon.id == weapon_id:
			weapon.level_up()
			return true
	return false

func has_object_with_id(object_id: String) -> Node:
	# Recorre los items
	for item in items:
		if item.id == object_id:
			return item

	# Recorre las armas
	for weapon in weapons:
		if weapon.id == object_id:
			return weapon

	# Si no se encuentra, retorna null
	return null


func _physics_process(delta):
	
	show_score()
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * moveVel
	
	move_and_slide()
	
	if velocity.length() != 0:
		$HappyBoo.play_walk_animation()
		idle = false

		# ➤ EFECTO ESPEJO SEGÚN DIRECCIÓN HORIZONTAL
		if velocity.x > 0:
			$HappyBoo.scale.x = -1  # Voltear a la derecha
		elif velocity.x < 0:
			$HappyBoo.scale.x = 1   # Volver a la forma original (mirar a la izquierda)

	else:
		if !idle:
			$HappyBoo.play_idle_animation()
			idle = true
	
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	
	for mob in overlapping_mobs:
		health -= DAMAGE_RATE * mob.damage * delta
		%ProgressBarHealth.value = health
		if health <= 0.0:
			health_depleted.emit()

		

func reloadProgressBarHealth():
	progressBarHealth.max_value = maxHealth
	progressBarHealth.value = health

func reloadLevelLabel():
	%LevelLabel.text = "Lvl %d" % [level]

func show_object_summary() :
	var result := "Objetos:\n"
	result += "Armas:\n"
	for weapon in weapons:
		result += "- %s: Nivel %d\n" % [weapon.objectName, weapon.level]

	result += "Items:\n"
	for item in items:
		result += "- %s: Nivel %d\n" % [item.objectName, item.level]

	%ObjectsLabel.text = result


func show_score() :
	var result = "Puntaje: %d" % [score]
	%ScoreLabel.text = result


func _on_minute_timer_timeout() -> void:
	total_seconds += 1
	update_time_label()
	
func update_time_label():
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	$PlayedTime.text = " %02d:%02d" % [minutes, seconds]

func health_player():
	health = maxHealth
	%ProgressBarHealth.value = health
