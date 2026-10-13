extends CharacterBody2D
class_name NPC

const PUZZLE_SCENE := preload("res://Scenes/puzzle.tscn") # your path

var puzzle: Puzzle

func _ready() -> void:
	puzzle = PUZZLE_SCENE.instantiate() as Puzzle
	puzzle.hide()   
	puzzle.puzzle_father = self
	
	puzzle.success.connect(_on_puzzle_success)
	puzzle.failure.connect(_on_puzzle_failure)
	

func _on_puzzle_success() -> void:
	print("Puzzle solved")

func _on_puzzle_failure(location: Vector2) -> void:
	print("Puzzle failed at ", location)
	
##DEBUG THINGY
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		puzzle.visible = true
		print("doningngi")
