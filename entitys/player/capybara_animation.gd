extends Node2D

func play_idle_animation():
	%AnimationPlayer.play("idle")
	%quieto.visible = true
	%Caminar.visible = false

func play_walk_animation():
	%AnimationPlayer.play("run")
	%quieto.visible = false
	%Caminar.visible = true
