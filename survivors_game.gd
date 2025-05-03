extends Node2D


var spawnCooldown: float = 2
var mobDamage = 1
var mobHealth = 3
var mobSpawnRatio = 2.0
var scoreData: Array[int] = [0]
var boosSpawned = false
var sceneExist = false

func _init():
	spawnCooldown = 2
	scoreData = [0]
	
	

func _ready():
	var canciones = [
		preload("res://UI/Musica/Maluma - Cuatro Babys (Official Video) ft. Trap Capos, Noriel, Bryant Myers, Juhn.mp3"),
		preload("res://UI/Musica/Tú Con Él.mp3"),
		preload("res://UI/Musica/Yerba Brava - La Cumbia de los Trapos.mp3")
	]
	
	var cancion_aleatoria = canciones[randi() % canciones.size()]
	
	$MusicPlayer.stream = cancion_aleatoria
	$MusicPlayer.play()

	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()
	%Timer.wait_time = spawnCooldown
	

func spawn_mob():
	var mob_rojo_scene = preload("res://entitys/enemys/slime/slimeRojo/mobRojo.tscn")
	var mob_verde_scene = preload("res://entitys/enemys/slime/SlimeVerde/mobVerde.tscn")
	var mob_morado_scene = preload("res://entitys/enemys/slime/slimeMorado/mobMorado.tscn")

	var selected_mob_scene
	var rand := randf()
	if rand < 0.33:
		selected_mob_scene = mob_rojo_scene
	elif rand < 0.66:
		selected_mob_scene = mob_verde_scene
	else:
		selected_mob_scene = mob_morado_scene

	for attempt in range(10):  # Intenta hasta 10 posiciones distintas
		%PathFollow2D.progress_ratio = randf()
		var spawn_pos = %PathFollow2D.global_position
		if is_position_free(spawn_pos):
			var mob_instance = selected_mob_scene.instantiate()
			mob_instance.initialize(mobHealth, mobDamage)
			mob_instance.global_position = spawn_pos
			add_child(mob_instance)
			return  # Salir si se logró spawnear
	




func spawn_boss():
	var boss_scene = preload("res://entitys/enemys/slime_boss/slimeBoss.tscn")
	var attempt_limit = 10  # Número de intentos para encontrar posición libre
	var boss_instance
	var position_valid = false
	boosSpawned = true

	for i in range(attempt_limit):
		%PathFollow2D.progress_ratio = randf()
		var candidate_position = %PathFollow2D.global_position
		if is_position_free(candidate_position, 24.0):  # Ajusta el radio si es necesario
			boss_instance = boss_scene.instantiate()
			boss_instance.initialize(mobHealth * 5, mobDamage * 5)
			boss_instance.global_position = candidate_position
			add_child(boss_instance)
			position_valid = true
			break

func spawn_bunch_mob():
	var center = %PathFollow2D.global_position
	var slime_scene = preload("res://entitys/enemys/slime/SlimeVerde/mobVerde.tscn")
	var spacing = 32  # espacio entre slimes en x e y

	for y in range(4):
		for x in range(4):
			# Omitir esquinas
			var is_corner = (x == 0 and y == 0) or (x == 0 and y == 3) or (x == 3 and y == 0) or (x == 3 and y == 3)
			if is_corner:
				continue

			var offset = Vector2((x - 1.5) * spacing, (y - 1.5) * spacing)
			var spawn_position = center + offset

			if is_position_free(spawn_position, 16.0):  # Ajusta el radio según el tamaño del slime
				var slime = slime_scene.instantiate()
				slime.initialize(mobHealth, mobDamage)
				slime.global_position = spawn_position
				add_child(slime)



func difficulty_up(m = 0):
	if m < 7:
		return
	elif 7 <= m and m < 10:
		mobDamage = mobDamage * 1.25
		mobHealth = mobDamage *2
		if mobSpawnRatio >  0.15: mobSpawnRatio = mobSpawnRatio * 0.7	
		
		%Timer.wait_time = mobSpawnRatio
		return
	elif 10  <= m and m < 14:
		mobDamage = mobDamage * 1.5
		mobHealth = mobDamage * 3
		if mobSpawnRatio > 0.15: mobSpawnRatio = mobSpawnRatio * 0.6
		%Timer.wait_time = mobSpawnRatio
		return
	else:
		mobDamage = mobDamage * 1.75
		mobHealth = mobDamage * 5
		if mobSpawnRatio >  0.15: mobSpawnRatio = mobSpawnRatio * 0.5
		%Timer.wait_time = mobSpawnRatio
		spawn_bunch_mob()
		return
		
func is_position_free(position: Vector2, radius := 12.0) -> bool:
	var space_state = get_world_2d().direct_space_state

	var shape = CircleShape2D.new()
	shape.radius = radius

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0, position)
	query.collision_mask = 1  # Ajusta esto a la capa de colisión de obstáculos
	query.exclude = []

	var result = space_state.intersect_shape(query, 1)
	return result.is_empty()



func _on_timer_timeout() -> void:
	spawn_mob()



func _on_player_health_depleted() -> void:
	if !sceneExist:			
		var gameOver = preload("res://utils/GamOver/game_over.tscn").instantiate()
		get_tree().get_root().add_child(gameOver)
		gameOver.position = %Player.global_position
		sceneExist = true
		get_tree().paused = true
		
func show_win_scene():
	if !sceneExist:			
		var gameOver = preload("res://utils/WinUI/win_UI.tscn").instantiate()
		get_tree().get_root().add_child(gameOver)
		gameOver.position = %Player.global_position
		sceneExist = true
		get_tree().paused = true
	



func _on_regresion_timer_timeout() -> void:
	scoreData.append(get_node("Player").score)
	print(scoreData)

	if scoreData.size() == 5:
		var n = scoreData.size()
		var sum_x = 0.0
		var sum_y = 0.0
		var sum_xy = 0.0
		var sum_x2 = 0.0

		for i in range(n):
			var x = (i + 1) * 15.0  # Tiempo en segundos: 15, 30, 45, ...
			var y = scoreData[i]

			sum_x += x
			sum_y += y
			sum_xy += x * y
			sum_x2 += x * x

		var numerator = n * sum_xy - sum_x * sum_y
		var denominator = n * sum_x2 - sum_x * sum_x
	
		var slope = 0.0
		if denominator != 0:
			slope = numerator / denominator
			print("Pendiente de score respecto al tiempo: ", slope)
		else:
			print("No se puede calcular la pendiente (división por cero)")
		var last_score = scoreData[-1]	

		scoreData.clear()
		scoreData.append(last_score) 
		
		if !boosSpawned : difficulty_up(slope)


func _on_boss_timer_timeout() -> void:
	spawn_boss()
