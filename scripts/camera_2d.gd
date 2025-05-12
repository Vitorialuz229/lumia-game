extends Camera2D

@export var target: Node2D

var fixed_y = 0.0

func _ready():
	if target:
		fixed_y = global_position.y

func _process(delta):
	if target:
		global_position.x = target.global_position.x
		global_position.y = fixed_y
