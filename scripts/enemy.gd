extends CharacterBody2D

const BULLET = preload("res://bullet.tscn")

enum Estado { BUSCAR, DISPARAR, REPOSICIONAR, RECARGAR }
var estado_actual = Estado.REPOSICIONAR

@export var objetivo: CharacterBody2D
@export var distancia_ataque = 400.0
@export var speed = 250.0

var is_Moving = false
var puedo_disparar = true

var knockback_force = Vector2.ZERO
var desired_velocity = Vector2.ZERO

@onready var punto_reposicion = obtener_punto_aleatorio_seguro()

func _physics_process(_delta):
	desired_velocity = Vector2.ZERO
	
	match estado_actual:
		Estado.BUSCAR:
			estado_buscar()
		Estado.DISPARAR:
			estado_disparar()
		Estado.REPOSICIONAR:
			estado_reposicionar()
		Estado.RECARGAR:
			is_Moving = false
	
	velocity = desired_velocity + knockback_force
	move_and_slide()
	knockback_force = knockback_force.lerp(Vector2.ZERO, 0.1)

func estado_buscar():
	moverse_hacia(objetivo.global_position)
	if global_position.distance_to(objetivo.global_position) < distancia_ataque:
		estado_actual = Estado.DISPARAR

func estado_disparar():
	is_Moving = false
		
	if puedo_disparar:
		disparar()
		puedo_disparar = false
		punto_reposicion = obtener_punto_aleatorio_seguro()
		estado_actual = Estado.REPOSICIONAR

func estado_reposicionar():
	moverse_hacia(punto_reposicion)
	if global_position.distance_to(punto_reposicion) < 20:
		cambiar_a_recargar(1.1)

func cambiar_a_recargar(tiempo = 1.1):
	estado_actual = Estado.RECARGAR
	$TimerReload.start(tiempo)

func moverse_hacia(target_pos):
	var direction = global_position.direction_to(target_pos)
	var distance = global_position.distance_to(target_pos)
	var target_angle = direction.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_angle, 0.1)
	
	if distance > 10:
		is_Moving = true
		desired_velocity = direction * speed
	else:
		is_Moving = false
		desired_velocity = Vector2.ZERO

func obtener_punto_aleatorio_seguro() -> Vector2:
	var screen_size = get_viewport_rect().size
	var punto_valido = false
	var nuevo_punto = Vector2.ZERO
	
	while not punto_valido:
		nuevo_punto.x = randf_range(50, screen_size.x - 50)
		nuevo_punto.y = randf_range(50, screen_size.y - 50)
		
		# Verificamos que el punto no esté muy cerca del jugador (ej. 300px)
		if nuevo_punto.distance_to(objetivo.global_position) > 300:
			punto_valido = true
			
	return nuevo_punto
	
func disparar():
	var bullet = BULLET.instantiate()
	bullet.setBullet_visual(true)
	bullet.global_transform = $turret/bulletPosition.global_transform
	get_tree().root.add_child(bullet)
	
	bullet.set_collision_mask_value(1, true)
	bullet.set_collision_mask_value(2, false)
	
	var tween = create_tween()
	tween.tween_property($turret, "position", Vector2.DOWN.rotated(rotation) * 10, 0.1).as_relative()
	tween.tween_property($turret, "position", Vector2.ZERO, 0.1)

	var knockback_direction = Vector2.DOWN.rotated(global_rotation)
	var new_knockback_force = knockback_direction * 600
	apply_force(new_knockback_force)
	
func apply_force(force):
	knockback_force = force

func _on_timer_reload_timeout() -> void:
	puedo_disparar = true
	estado_actual = Estado.BUSCAR
