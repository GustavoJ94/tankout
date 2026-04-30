extends Node2D

@export var objetivo: CharacterBody2D

func _process(delta):
	if objetivo:
		var direccion_al_jugador = (objetivo.global_position - global_position).angle()
		var angulo_target = direccion_al_jugador + deg_to_rad(90)
		global_rotation = lerp_angle(global_rotation, angulo_target, 8.0 * delta)
