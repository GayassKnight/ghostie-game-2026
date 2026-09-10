extends CharacterBody2D
class_name StateMachineSimple

#Export variables
@export var destinations:Array[Marker2D]
@export var exit_destination:Marker2D

#Onready variables
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var idle_timer: Timer = $IdleTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var human_npc: StateMachineSimple = $"."

#Regular variables
const SPEED = 900
enum HumanStates {IDLE, WALKING, POSSESED}
var current_state: HumanStates
var current_destination:Marker2D

#Ready and Physics functions
func _ready() -> void:
	_set_state(HumanStates.IDLE)

func _physics_process(delta: float) -> void:
	match current_state:
		HumanStates.IDLE:
			pass
		HumanStates.WALKING:
			var next_path:Vector2 = navigation_agent_2d.get_next_path_position()
			var new_velocity:Vector2 = global_position.direction_to(next_path) * SPEED
			velocity = new_velocity
			var look_target:Vector2 = Vector2(next_path.x,next_path.y)
			if not global_position.is_equal_approx(look_target):
				look_at(look_target)
			move_and_slide()
		HumanStates.POSSESED:
			pass

#Custom functions
func _set_state(new_state:HumanStates) -> void:
	current_state = new_state
	
	match current_state:
		HumanStates.IDLE:
			idle_timer.start(1 + randf())
			animated_sprite.play("Idle")
			pass
		HumanStates.WALKING:
			animated_sprite.play("Walking")
		HumanStates.POSSESED:
			pass

func choose_next_state() -> void:
	if current_state == HumanStates.IDLE:
		current_destination = destinations.pick_random()
		navigation_agent_2d.target_position = current_destination.global_position
		_set_state(HumanStates.WALKING)

#Connected Signals
func _on_idle_timer_timeout() -> void:
	choose_next_state()

func _on_navigation_agent_2d_navigation_finished() -> void:
	if current_destination == exit_destination:
		despawn()
	else:
		_set_state(HumanStates.IDLE)

func despawn() -> void:
	human_npc.get_parent().remove_child(self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
