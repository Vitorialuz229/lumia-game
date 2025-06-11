extends "res://scripts/levels/base_level.gd"

var orbs_necessarios = 0
@onready var animation_player = $AnimationPlayer


func get_level_orb_type() -> String:
	return "raiva"


func _on_transition_trigger_body_entered(body):
	if body.name == "Cynthia":
		var orbs_coletados_count = 0
		if Globals.save_data.has("orbs_collected"):
			orbs_coletados_count = Globals.save_data.orbs_collected.size()

		if orbs_coletados_count >= orbs_necessarios:
			start_level_transition()


func start_level_transition():
	cynthia.set_player_control(false)
	animation_player.play("TransitionToTristeza")


func _change_to_next_level():
	if Globals.save_data.has("orbs_collected"):
		Globals.save_data.orbs_collected.clear()

	SceneTransition.fade_to_scene("res://scenes/levels/Level_Tristeza.tscn")
