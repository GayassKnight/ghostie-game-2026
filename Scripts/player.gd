extends CharacterBody2D
class_name Player

const SPEED = 300.0

func _ready() -> void:
	set_collision_mask_value(2, false)
	set_collision_mask_value(3,true)
	
func _physics_process(_delta: float) -> void:
	
	var direction = Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down"))
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(0.0,0.0)
	
	move_and_slide()
