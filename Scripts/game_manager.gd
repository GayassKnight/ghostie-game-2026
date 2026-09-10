extends Node

#Regular variables
var max_npcs = 20
var current_npcs: Array

func _ready() -> void:
	pass

func add_npcs_tree() -> void:
	var filled_slots = 0
	for slot in current_npcs:
		if slot != null:
			filled_slots += 1
	
	
	
