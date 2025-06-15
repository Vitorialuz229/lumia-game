extends "res://scripts/levels/base_level.gd"


var orbs_necessarios = 1
var orbs_coletados_neste_nivel = 0

@onready var animation_player = $AnimationPlayer
@onready var barrier_message = $TransitionTrigger/BarrierMessage
@onready var message_timer = $MessageTimer

func _ready():
	super._ready()
	message_timer.timeout.connect(_on_MessageTimer_timeout)


func get_level_orb_type() -> String:
	return "alegria"

func on_orb_collected():
	orbs_coletados_neste_nivel += 1


func _on_transition_trigger_body_entered(body):
	if body.name == "Cynthia":
		var orbs_coletados_count = 0
		if Globals.save_data.has("orbs_collected"):
			orbs_coletados_count = Globals.save_data.orbs_collected.size()
		
		if orbs_coletados_neste_nivel >= orbs_necessarios:
			start_level_transition()
		else:
			barrier_message.visible = true
			message_timer.start(3) 

func start_level_transition():
	cynthia.set_player_control(false)
	animation_player.play("TransitionToFim")

func _change_to_next_level():
	if Globals.save_data.has("orbs_collected"):
		Globals.save_data.orbs_collected.clear()
	
	Globals.save_data["current_level"] = "fim"
	Globals.save_game()
	SceneTransition.fade_to_scene("res://scenes/levels/fim.tscn")

func _on_MessageTimer_timeout():
	barrier_message.visible = false
