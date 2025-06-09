extends Control

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

func _ready():
	animation_player.play("MostrarTudo")
	timer.timeout.connect(_on_Timer_timeout)

func _on_Timer_timeout():
	#get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
	SceneTransition.fade_to_scene("res://scenes/ui/MainMenu.tscn")
