extends Node

#Onready variables
@onready var game_manager: Node = $"."
@onready var game: Node2D = $".."
@onready var spawn_timer: Timer = $"../SpawnTimer"

#Regular variables
var max_npcs = 20
var current_npcs: Array
var npc_scene = preload("res://Scenes/human_npc.tscn") as PackedScene

func _ready() -> void:
	current_npcs.resize(max_npcs)
	spawn_timer.start()

func add_npcs_tree() -> void:
	var filled_slots = 0
	for slot in current_npcs:
		if slot != null:
			filled_slots += 1
	
	for n in max_npcs:
			var new_NPC = HumanNPC.new()
			current_npcs.append(new_NPC)
			game.add_child(new_NPC)


func _on_spawn_timer_timeout() -> void:
	var filled_slots = 0
	for slot in current_npcs:
		if slot != null:
			filled_slots += 1
	
	if filled_slots != max_npcs:
		var new_NPC = npc_scene.instantiate()
		new_NPC.global_position = Vector2(608,40)
		new_NPC.set_destination(get_tree().get_nodes_in_group("Shops"))
		new_NPC.exit_destination = $"../BackgroundAndNavigation/Exit/Exit"
		game.add_child.call_deferred(new_NPC)
		current_npcs.append(new_NPC)
