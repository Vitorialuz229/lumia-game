extends AnimatedSprite2D

func _ready():
	var anim_names = ["blue", "red", "yellow", "grey", "pink", "white"]
	play(anim_names[randi() % anim_names.size()])
	flip_h = randf() > 0.5 
