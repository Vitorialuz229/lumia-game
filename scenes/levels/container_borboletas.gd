extends Node

@export var butterfly_count := 20
@export var spawn_area := Rect2(0, 0, 1280, 720)

var colors = ["blue", "red", "yellow", "grey", "pink", "white"]

func _ready():
	for i in butterfly_count:
		spawn_butterfly()

func spawn_butterfly():
	var butterfly = preload("res://scenes/personagem/borboletas.tscn").instantiate()
	
	# Posição aleatória
	butterfly.position = Vector2(
		randf_range(spawn_area.position.x, spawn_area.end.x),
		randf_range(spawn_area.position.y, spawn_area.end.y)
	)
	
	var chosen_color = colors[randi() % colors.size()]
	var sprite_frames_path = "res://assets/sprites/borboletas/%s.tres" % chosen_color
	
	if ResourceLoader.exists(sprite_frames_path):
		butterfly.get_node("AnimatedSprite2D").sprite_frames = load(sprite_frames_path)
	else:
		push_error("Arquivo não encontrado: ", sprite_frames_path)
		return
	
	add_child(butterfly)
