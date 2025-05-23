extends Area2D

@export var orb_type: String = "vazio"
var is_collected = false
@onready var collect_sound = $CollectSound

func _ready():
	$AnimatedSprite2D.play(orb_type)
	z_index = 0
	z_as_relative = false

func _on_body_entered(body: Node) -> void:
	if body.name == "Cynthia" and not is_collected:
		is_collected = true
		$CollisionShape2D.set_deferred("disabled", true)
		body.add_following_orb(self)
		if not Globals.save_data["orbs_collected"].has(orb_type):
			Globals.save_data["orbs_collected"].append(orb_type)
		Globals.save_game()
		
		# toca o som
		if collect_sound:
			collect_sound.play()
