extends Line2D

var player: CharacterBody2D

func _ready() -> void:
	player = get_parent().get_parent()

func _physics_process(_delta: float) -> void:
	if player.is_Moving:
		if not $Timer.is_stopped():
			$Timer.stop()
			modulate.a = 1.0
		add_point(get_parent().global_position)
	else:
		if $Timer.is_stopped() and points.size() > 0:
			$Timer.start()

func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.finished.connect(func():
		clear_points()
		modulate.a = 1.0
	)
