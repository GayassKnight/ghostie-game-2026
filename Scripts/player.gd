extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	
	var direction = Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down"))
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(0.0,0.0)
	
	move_and_slide()
