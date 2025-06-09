extends BaseLevel

@onready var animation_player = $AnimationPlayer

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


func _on_final_trigger_body_entered(body):
	if body.name == "Cynthia":
		cynthia.set_player_control(false)
		animation_player.play("CenaFinal")


func _end_game():
	get_tree().change_scene_to_file("res://scenes/ui/TelaFinal.tscn")
