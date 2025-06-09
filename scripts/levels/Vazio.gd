extends "res://scripts/levels/base_level.gd"

@onready var orb_path_follow = $OrbPath/OrbPathFollow
@onready var fugitive_orb = $OrbPath/OrbPathFollow/FugitiveOrb
@onready var tutorial_ui = $TutorialUI
@onready var walk_prompt = $TutorialUI/WalkPrompt
@onready var jump_prompt = $TutorialUI/JumpPrompt
@onready var animation_player = $AnimationPlayer 

var orb_target_progress = 0.0
var orb_speed = 50.0

func get_level_orb_type() -> String:
	return "vazio"

func _ready():
	walk_prompt.visible = false
	jump_prompt.visible = false
	animation_player.play("StartCutscene")
	fugitive_orb.setup()


func _process(delta):
	orb_path_follow.progress = lerp(orb_path_follow.progress, orb_target_progress, delta * 1.5)

	var distance_to_orb = cynthia.global_position.distance_to(fugitive_orb.global_position)
	if distance_to_orb < 400 and orb_target_progress < orb_path_follow.get_parent().curve.get_baked_length():
		orb_target_progress = min(orb_path_follow.progress + 200, orb_path_follow.get_parent().curve.get_baked_length())


func _on_walk_trigger_body_entered(body):
	if body.name == "Cynthia":
		walk_prompt.visible = true

func _on_jump_trigger_body_entered(body):
	if body.name == "Cynthia":
		print("DEBUG: Cynthia detectada no JumpTrigger! Tocando animação do prompt.")
		# walk_prompt.visible = false
		# jump_prompt.visible = true 
		# E esta flag, se você a tiver:
		# force_show_jump_prompt = true

		# Esconde o prompt de andar (se ele ainda estiver visível)
		walk_prompt.visible = false
		
		# Adicionamos esta linha para tocar a animação:
		animation_player.play("ShowJumpPrompt")

func _on_fall_trigger_body_entered(body):
	if body.name == "Cynthia":
		jump_prompt.visible = false
		animation_player.play("FallTransition")

func _change_to_medo():
	get_tree().change_scene_to_file("res://scenes/levels/Level_Medo.tscn")
