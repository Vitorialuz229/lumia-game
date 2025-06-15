extends "res://scripts/levels/base_level.gd"


func get_level_orb_type() -> String:
	return "medo"

var orbs_necessarios = 1
var orbs_coletados_neste_nivel = 0

@onready var steps_approach = $steps_approach
@onready var laughing = $laughing
@onready var animation_player = $AnimationPlayer
@onready var barrier_message = $TransitionTrigger/BarrierMessage
@onready var message_timer = $MessageTimer

var min_interval = 1.0
var max_interval = 7.0


func _ready():
	super._ready()
	play_random_sound()
	message_timer.timeout.connect(_on_MessageTimer_timeout)

func on_orb_collected():
	orbs_coletados_neste_nivel += 1

func play_random_sound() -> void:
	var sounds = [steps_approach, laughing]
	var sound_to_play = sounds[randi() % sounds.size()]
	if not sound_to_play.playing:
		sound_to_play.play()
	var wait_time = randf_range(min_interval, max_interval)
	await get_tree().create_timer(wait_time).timeout
	play_random_sound()


func _on_transition_trigger_body_entered(body):
	if body.name == "Cynthia":
		var orbs_coletados_count = 0
		if Globals.save_data.has("orbs_collected"):
			orbs_coletados_count = Globals.save_data.orbs_collected.size()
		
		print("Cyntia no trigger. Coletados: ", orbs_coletados_count, "/", orbs_necessarios)

		if orbs_coletados_neste_nivel >= orbs_necessarios:
			start_level_transition()
		else:
			barrier_message.visible = true
			message_timer.start(3) 

func start_level_transition():
	print("Iniciando transição para a próxima fase...")
	cynthia.set_player_control(false)
	animation_player.play("TransitionToRaiva")

func _change_to_next_level():
	if Globals.save_data.has("orbs_collected"):
		Globals.save_data.orbs_collected.clear()
	
	Globals.save_data["current_level"] = "raiva"
	Globals.save_game()
	SceneTransition.fade_to_scene("res://scenes/levels/Level_Raiva.tscn")

func _on_MessageTimer_timeout():
	barrier_message.visible = false
