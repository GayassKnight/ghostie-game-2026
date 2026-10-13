extends Control
class_name Puzzle

signal success
signal failure(location)
var puzzle_father: Node2D

func _on_not_ok_button_pressed() -> void:
	failure.emit(puzzle_father.global_position)

func _on_ok_button_pressed() -> void:
	success.emit()
