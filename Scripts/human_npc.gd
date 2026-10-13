extends CharacterBody2D
class_name HumanNPC

#Export variables
@export var destinations:Array
@export var exit_destination:Marker2D

#Onready variables
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var idle_timer: Timer = $IdleTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var human_npc: HumanNPC = $"."
@onready var interactable: Area2D = $Interactable

#Regular variables
const SPEED = 1000
enum HumanStates {IDLE, WALKING, POSSESED,DETECTED}
var current_state: HumanStates
var current_destination:Marker2D
const PUZZLE_SCENE := preload("res://Scenes/puzzle.tscn") # your path
var puzzle: Puzzle

#Ready and Physics functions
func set_destination(destination_list):
	if not destinations:
		destinations = []
	
	destinations.assign(destination_list)

func _ready() -> void:
	set_collision_layer_value(2, true)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3,true)
	z_index = 100
	_set_state(HumanStates.IDLE)
	interactable.interact = _on_interact
	
	##Puzzle logic
	puzzle = PUZZLE_SCENE.instantiate() as Puzzle
	puzzle.hide()   
	puzzle.puzzle_father = self
	
	puzzle.success.connect(_on_puzzle_success)
	puzzle.failure.connect(_on_puzzle_failure)

func _physics_process(_delta: float) -> void:
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
			idle_timer.stop()
			animated_sprite.play("Possesed")
		HumanStates.DETECTED:
			animated_sprite.play("Detected")

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
		set_physics_process(false)
	else:
		_set_state(HumanStates.IDLE)

func despawn() -> void:
	human_npc.get_parent().remove_child(self)
	
#Interacting part
func _on_interact():
	if (animated_sprite.animation == "Walking" && interactable.is_interactable==true) || (animated_sprite.animation == "Idle"&& interactable.is_interactable==true):
		_set_state(HumanStates.POSSESED)
		interactable.is_interactable = false
		add_child(puzzle)
		puzzle.visible = true
		puzzle.z_index = 150
		print("Puzzle opened")
		
func _on_puzzle_success() -> void:
	print("Puzzle solved")

func _on_puzzle_failure(location: Vector2) -> void:
	print("Puzzle failed at ", location)
