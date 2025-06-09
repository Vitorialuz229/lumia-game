extends CanvasLayer

@onready var animation = $AnimationPlayer

func fade_to_scene(scene_path: String):
	animation.play("fade_out")

	await animation.animation_finished

	get_tree().change_scene_to_file(scene_path)

	animation.play("fade_in")
