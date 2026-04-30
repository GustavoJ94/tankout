extends Node2D

const BULLET = preload("res://bullet.tscn")

func _process(_delta: float) -> void:
	var target_angle = (get_global_mouse_position() - global_position).angle()
	target_angle += deg_to_rad(90)
	global_rotation = lerp_angle(global_rotation, target_angle, 5.0 * _delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		shoot()
		
func shoot():
	var bullet = BULLET.instantiate()
	bullet.global_transform = $bulletPosition.global_transform
	get_tree().root.add_child(bullet)
	
	bullet.set_collision_mask_value(1, false)
	bullet.set_collision_mask_value(2, true)

	var tween = create_tween()
	tween.tween_property(self, "position", Vector2.DOWN.rotated(rotation) * 10, 0.1).as_relative()
	tween.tween_property(self, "position", Vector2.ZERO, 0.1)

	var knockback_direction = Vector2.DOWN.rotated(global_rotation)
	var knockback_force = knockback_direction * 600
	get_parent().apply_force(knockback_force)
