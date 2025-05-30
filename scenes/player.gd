extends CharacterBody2D

const SPEED = 64 * 1.5

func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("move_left", "move_right", "move_up", "moev_down")
	velocity = direction * SPEED
	move_and_slide()
