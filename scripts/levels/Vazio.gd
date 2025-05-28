extends "res://scripts/levels/base_level.gd"


func get_level_orb_type() -> String:
	return "vazio"


func spawn_level_orbs():
	var guide_orb = preload("res://scenes/personagem/orb.tscn").instantiate()
	guide_orb.orb_type = "vazio"
	guide_orb.position = Vector2(100, 300)
	add_child(guide_orb)
