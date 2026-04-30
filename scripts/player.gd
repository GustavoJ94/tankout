extends CharacterBody2D

var is_Moving = false
var targetPosition = Vector2.ZERO
var knockback_force = Vector2.ZERO
var desired_velocity = Vector2.ZERO
var speed = 250

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right"):
		is_Moving = true
		targetPosition = get_global_mouse_position()

func _physics_process(_delta: float) -> void:
	desired_velocity = Vector2.ZERO
	
	if is_Moving:
		var direction = global_position.direction_to(targetPosition)
		var distance = global_position.distance_to(targetPosition)
		
		var target_angle = direction.angle() + deg_to_rad(90)
		rotation = lerp_angle(rotation, target_angle, 0.1)
		
		if distance > 5:
			desired_velocity = direction * speed
		else:
			is_Moving = false
			
	velocity = desired_velocity + knockback_force
	move_and_slide()
	knockback_force = knockback_force.lerp(Vector2.ZERO, 0.1)
	
func apply_force(force):
	knockback_force = force
