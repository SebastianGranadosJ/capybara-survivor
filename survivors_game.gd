extends Node2D


var spawnCooldown: float = 2
var mobDamage = 1
var mobHealth = 3
var mobSpawnRatio = 2.0
var scoreData: Array[int] = [0]

func _init():
	spawnCooldown = 2
	scoreData = [0]
	
	

func _ready():
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_boss()
	%Timer.wait_time = spawnCooldown
	

func spawn_mob():
	var new_mob = preload("res://entitys/enemys/slime/mob.tscn").instantiate()
	new_mob.initialize(mobHealth,mobDamage)
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func spawn_boss():
	var new_mob = preload("res://entitys/enemys/slime_boss/slimeBoss.tscn").instantiate()
	new_mob.initialize(mobHealth * 5,mobDamage * 5)
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	

func spawn_bunch_mob():
	var center = %PathFollow2D.global_position
	var slime_scene = preload("res://entitys/enemys/slime/mob.tscn")
	var spacing = 32  # espacio entre slimes en x e y

	for y in range(4):
		for x in range(4):
			# Omitir esquinas
			var is_corner = (x == 0 and y == 0) or (x == 0 and y == 3) or (x == 3 and y == 0) or (x == 3 and y == 3)
			if is_corner:
				continue
			var slime = slime_scene.instantiate()
			slime.initialize(mobHealth, mobDamage)
			var offset = Vector2((x - 1.5) * spacing, (y - 1.5) * spacing)
			slime.global_position = center + offset
			add_child(slime)


func difficulty_up(m = 0):
	if m < 7:
		return
	elif 7 <= m and m < 10:
		mobDamage = mobDamage * 1.25
		mobHealth = mobDamage *2
		mobSpawnRatio = mobSpawnRatio * 0.7	
		%Timer.wait_time = mobSpawnRatio
		return
	elif 10  <= m and m < 14:
		mobDamage = mobDamage * 1.5
		mobHealth = mobDamage * 3
		mobSpawnRatio = mobSpawnRatio * 0.6
		%Timer.wait_time = mobSpawnRatio
		return
	else:
		mobDamage = mobDamage * 1.75
		mobHealth = mobDamage * 5
		mobSpawnRatio = mobSpawnRatio * 0.5
		%Timer.wait_time = mobSpawnRatio
		spawn_bunch_mob()
		return


func _on_timer_timeout() -> void:
	spawn_mob()


func _on_player_health_depleted() -> void:
	%GameOver.visible = true
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
		difficulty_up(slope)
