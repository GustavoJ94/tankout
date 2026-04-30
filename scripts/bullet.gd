extends Area2D

var speed = 600
const player_bullet = preload("uid://do7ruyq8lbt0t")
const enemy_bullet = preload("uid://nk11kbvcgjwh")

func setBullet_visual(is_enemy: bool) -> void:
	$Sprite2D.texture = player_bullet
	if is_enemy:
		$Sprite2D.texture = enemy_bullet
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.has_method("apply_force"):
		var direccion_impacto = global_position.direction_to(body.global_position)
		body.apply_force(direccion_impacto * 1000)
	
	queue_free()
