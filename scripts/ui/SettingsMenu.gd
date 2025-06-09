extends Control

@onready var cynthia_animation_player = $cynthia_idle
@onready var volume_slider = $Menu2/VolumeSlider

func _ready():
	cynthia_animation_player.play("idle")

	volume_slider.value_changed.connect(_on_volume_changed)

	var current_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	var linear_volume = db_to_linear(current_db)
	volume_slider.value = linear_volume * 100


func _on_BtnBack_pressed():
	SceneTransition.fade_to_scene("res://scenes/ui/MainMenu.tscn")

func _on_volume_changed(value: float):

	if value == 0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
	else:
		var linear_scale = value / 100.0
		var db_volume = linear_to_db(linear_scale)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_volume)
