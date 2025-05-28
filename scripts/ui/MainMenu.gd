extends Control

@onready var btn_start = $Menu/BtnStart
@onready var btn_continue = $Menu/BtnContinue
@onready var btn_settings = $Menu/BtnSettings
@onready var btn_exit = $Menu/BtnExit

@onready var lumia_animation_player = $lumia_animation
@onready var cynthia_animation_player = $cynthia_animation
@onready var parallax_bg = $ParallaxBackground

var scroll_speed = Vector2(5, 0) 


func _process(delta):
	parallax_bg.scroll_offset += scroll_speed * delta


func _ready():
	lumia_animation_player.play("titulo")
	cynthia_animation_player.play("cynthia_idle")

	if Globals.load_game():
		btn_continue.disabled = false
	else:
		btn_continue.disabled = true


func _play_click_feedback(button_node) -> Tween:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(button_node, "scale", Vector2(0.85, 0.85), 0.08)
	tween.tween_property(button_node, "scale", Vector2(1.0, 1.0), 0.1)
	return tween


func _on_BtnStart_pressed():
	var click_tween = _play_click_feedback(btn_start)
	await click_tween.finished
	Globals.save_data = {
		"current_phase": "vazio",
		"orbs_collected": [],
		"puzzle_checkpoint": null,
		"following_orbs": []
	}
	Globals.save_game()
	get_tree().change_scene_to_file("res://scenes/levels/vazio.tscn")


func _on_BtnContinue_pressed():
	var click_tween = _play_click_feedback(btn_continue)
	await click_tween.finished
	if Globals.load_game():
		var phase = Globals.save_data.get("current_phase", "vazio")
		match phase:
			"vazio":
				get_tree().change_scene_to_file("res://scenes/levels/vazio.tscn")
			"medo":
				get_tree().change_scene_to_file("res://scenes/levels/Level_Medo.tscn")
			"raiva":
				get_tree().change_scene_to_file("res://scenes/levels/Level_Raiva.tscn")
			"tristeza":
				get_tree().change_scene_to_file("res://scenes/levels/Level_Tristeza.tscn")
			"alegria":
				get_tree().change_scene_to_file("res://scenes/levels/Level_Alegria.tscn")
			"fim":
				get_tree().change_scene_to_file("res://scenes/levels/fim.tscn")
			_:
				get_tree().change_scene_to_file("res://scenes/levels/vazio.tscn")


func _on_BtnSettings_pressed():
	var click_tween = _play_click_feedback(btn_settings)
	await click_tween.finished
	get_tree().change_scene_to_file("res://scenes/ui/SettingsMenu.tscn")


func _on_BtnExit_pressed():
	var click_tween = _play_click_feedback(btn_exit)
	await click_tween.finished
	get_tree().quit()
