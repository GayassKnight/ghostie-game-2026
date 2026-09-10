extends Node

#Onready variables
@onready var game_manager: Node = $"."
@onready var game: Node2D = $".."

#Regular variables
var max_npcs = 20
var current_npcs: Array
var npc_scene = preload("res://Scenes/human_npc.tscn") as PackedScene

func _ready() -> void:
	var new_NPC = npc_scene.instantiate()
	new_NPC.global_position = Vector2(608,40)
	new_NPC.set_destination(get_tree().get_nodes_in_group("Shops"))
	new_NPC.z_index = 100
	new_NPC.exit_destination = $"../BackgroundAndNavigation/Exit/Exit"
	game.add_child.call_deferred(new_NPC)



func add_npcs_tree() -> void:
	var filled_slots = 0
	for slot in current_npcs:
		if slot != null:
			filled_slots += 1
	
	for n in max_npcs:
			var new_NPC = HumanNPC.new()
			current_npcs.append(new_NPC)
			game.add_child(new_NPC)
	
