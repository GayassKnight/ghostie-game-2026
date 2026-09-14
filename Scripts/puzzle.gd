extends Control

@onready var puzzle: Control = $"."

func _on_finish_pressed() -> void:
	puzzle.visible = false
