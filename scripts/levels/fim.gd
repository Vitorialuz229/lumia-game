extends BaseLevel

func _ready():
	show_collected_orbs()

func show_collected_orbs():
	if Globals.load_game():
		for i in range(Globals.save_data["collected_orbs"].size()):
			var orb = preload("res://scenes/personagem/orb.tscn").instantiate()
			orb.orb_type = Globals.save_data["collected_orbs"][i]
			orb.position = Vector2(200 + i * 100, 300)
			orb.is_collected = true
			add_child(orb)
