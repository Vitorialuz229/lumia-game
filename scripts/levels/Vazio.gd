extends Node2D

func _ready():
	load_saved_orbs()
	spawn_orbs()

func load_saved_orbs():
	const Orb = preload("res://scripts/personagem/Orb.gd")
	if Globals.load_game():
		for pos_array in Globals.save_data.get("following_orbs_positions", []):
			var pos = Vector2(pos_array[0], pos_array[1])
			var orb_scene = preload("res://scenes/personagem/orb.tscn")
			var orb = orb_scene.instantiate() as Orb
			orb.global_position = pos
			orb.is_collected = true
			orb.get_node("CollisionShape2D").disabled = true
			add_child(orb)
			$Cynthia.following_orbs.append(orb)

func spawn_orbs():
	var orb_positions = [
		Vector2(300, 400),
		Vector2(500, 300)
	]
	
	for pos in orb_positions:
		var orb_scene = preload("res://scenes/personagem/orb.tscn")
		var orb = orb_scene.instantiate() as Area2D
		orb.global_position = pos
		orb.orb_type = name.to_lower()
		add_child(orb)
