extends Node2D
class_name BaseLevel

@onready var cynthia = $Cynthia
@onready var orb_spawns = $OrbSpawns.get_children() if has_node("OrbSpawns") else []


func _ready():
	load_persistent_orbs()
	spawn_level_orbs()


func load_persistent_orbs():
	if Globals.load_game() and is_instance_valid(cynthia):
		for orb_data in Globals.save_data.get("following_orbs", []):
			# Verifica se o orb já está sendo seguido
			var orb_exists = false
			for existing_orb in cynthia.following_orbs:
				if existing_orb.orb_type == orb_data["type"]:
					orb_exists = true
					break

			if not orb_exists:
				var orb = preload("res://scenes/personagem/orb.tscn").instantiate()
				orb.orb_type = orb_data["type"]
				orb.is_collected = true
				orb.get_node("CollisionShape2D").disabled = true
				cynthia.call_deferred("add_following_orb", orb)


func spawn_level_orbs():
	for spawn in orb_spawns:
		var orb = preload("res://scenes/personagem/orb.tscn").instantiate()
		orb.orb_type = get_level_orb_type()
		orb.position = spawn.position
		add_child(orb)


func get_level_orb_type() -> String:
	return name.to_lower().replace("level_", "")
