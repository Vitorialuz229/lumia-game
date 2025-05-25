extends "res://scripts/levels/base_level.gd"


func get_level_orb_type() -> String:
	return "medo"

@onready var steps_approach = $steps_approach
@onready var laughing = $laughing

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
