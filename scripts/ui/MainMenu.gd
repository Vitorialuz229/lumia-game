extends Control

@onready var btn_continue = $Menu/BtnContinue

func _ready():
	if Globals.load_game():
		btn_continue.disabled = false
	else:
		btn_continue.disabled = true

func _on_BtnStart_pressed():
	# Começa jogo novo
	Globals.save_data = {
		"current_phase": "vazio",
		"orbs_collected": 0,
		"puzzle_checkpoint": null
	}
	Globals.save_game()
	get_tree().change_scene_to_file("res://scenes/levels/vazio.tscn")

func _on_BtnContinue_pressed():
	if Globals.load_game():
		var phase = Globals.save_data.get("current_phase", "vazio")
		match phase:
			"vazio":
				get_tree().change_scene_to_file("res://scenes/levels/vazio.tscn")
			"medo":
				get_tree().change_scene_to_file("res://scenes/levels/medo.tscn")
			"raiva":
				get_tree().change_scene_to_file("res://scenes/levels/raiva.tscn")
			"tristeza":
				get_tree().change_scene_to_file("res://scenes/levels/tristeza.tscn")
			"alegria":
				get_tree().change_scene_to_file("res://scenes/levels/alegria.tscn")
			"fim":
				get_tree().change_scene_to_file("res://scenes/levels/fim.tscn")
			_:
				get_tree().change_scene_to_file("res://scenes/levels/vazio.tscn")

func _on_BtnSettings_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/SettingsMenu.tscn")

func _on_BtnExit_pressed():
	get_tree().quit()
