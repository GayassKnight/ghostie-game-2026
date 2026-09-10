extends Node

@onready var player_count_screen: Node = $".."
@onready var canvas_layer: CanvasLayer = $PlayerLayer
@onready var player_manager: Node = $"."

var player_count = 2
var clue_turns_per_player = 0
var starting_players = []
var final_players = []
var hit_once = true

signal players_size(player_nodes: Array)

func _on_counter_players_submitted(players_submitted_count: Variant) -> void:
	player_count = players_submitted_count
	add_players_array_tree()

func _on_counter_continue_pressed() -> void:
	players_size.emit(starting_players)

func add_players_array_tree() -> void:
	var filled_slots = 0
	for slot in starting_players:
		if slot != null:
			filled_slots += 1
	
	if hit_once:
		for n in player_count:
			var new_player = Sprite2D.new()
			new_player.name = "PlayerNode" +str(n+1)
			starting_players.append(new_player)
			player_manager.add_child(new_player)
		hit_once = false
		final_players = starting_players
	else:
		if filled_slots < player_count:
			var new_player = Sprite2D.new()
			new_player.name = "PlayerNode" +str(filled_slots+1)
			starting_players.append(new_player)
			player_manager.add_child(new_player)
			final_players = starting_players
		elif filled_slots > player_count:
			var player_to_remove = starting_players[player_count]
			starting_players.remove_at(player_count)
			player_to_remove.queue_free()
			final_players = starting_players
