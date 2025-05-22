extends Area2D

@export var orb_type: String = "vazio"
var is_collected = false

func _ready():
	$AnimatedSprite2D.play(orb_type)
	z_index = 0
	z_as_relative = false

func _on_body_entered(body: Node) -> void:
	if body.name == "Cynthia" and not is_collected:
		coletar_orb(body)

func coletar_orb(player):
	is_collected = true
	$CollisionShape2D.set_deferred("disabled", true)
	player.add_following_orb(self)
	if not Globals.save_data["orbs_collected"].has(orb_type):
		Globals.save_data["orbs_collected"].append(orb_type)
	Globals.save_game()
