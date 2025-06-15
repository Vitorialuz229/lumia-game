extends BaseLevel

@onready var animation_player = $AnimationPlayer
@onready var guide_orb_path_follow = $FinalGuidePath/GuideOrbPathFollow

var follow_distance_ahead = 200.0

func _ready():
	super._ready() 
	animation_player.play("AparecerOrbGuia")

func _process(delta):
	if not is_instance_valid(cynthia) or not is_instance_valid(guide_orb_path_follow):
		return

	var target_progress = cynthia.global_position.x + follow_distance_ahead

	guide_orb_path_follow.progress = lerp(guide_orb_path_follow.progress, target_progress, delta * 2.0)

func _on_final_trigger_body_entered(body):
	if body.name == "Cynthia":
		cynthia.set_player_control(false)
		animation_player.play("CenaFinal")


func _end_game():
	get_tree().change_scene_to_file("res://scenes/ui/TelaFinal.tscn")
