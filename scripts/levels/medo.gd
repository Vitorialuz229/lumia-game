extends "res://scripts/levels/base_level.gd"


func get_level_orb_type() -> String:
	return "medo"

var orbs_necessarios = 0
@onready var steps_approach = $steps_approach
@onready var laughing = $laughing
@onready var animation_player = $AnimationPlayer

var min_interval = 1.0
var max_interval = 7.0


func _ready():
	play_random_sound()


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
		# Pega a contagem de orbs do seu sistema global
		# Assumindo que Globals.save_data.orbs_collected é um array
		var orbs_coletados_count = 0
		if Globals.save_data.has("orbs_collected"):
			orbs_coletados_count = Globals.save_data.orbs_collected.size()
		
		print("Cyntia no trigger. Coletados: ", orbs_coletados_count, "/", orbs_necessarios)

		# A condição para iniciar a transição
		if orbs_coletados_count >= orbs_necessarios:
			start_level_transition()
		else:
			print("Condição não atendida. Transição não iniciada.")
			# Opcional: Mostre uma mensagem ao jogador aqui

# Função que inicia a animação
func start_level_transition():
	print("Iniciando transição para a próxima fase...")
	cynthia.set_player_control(false)
	animation_player.play("TransitionToRaiva")

# Função que a animação chama no final para carregar a próxima cena
func _change_to_next_level():
	# Zera a contagem de orbs para a próxima fase
	if Globals.save_data.has("orbs_collected"):
		Globals.save_data.orbs_collected.clear()
	
	SceneTransition.fade_to_scene("res://scenes/levels/Level_Raiva.tscn")
