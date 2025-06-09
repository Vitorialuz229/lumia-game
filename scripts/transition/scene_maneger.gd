extends CanvasLayer

signal transitioned_in()
signal transitioned_out()

@onready var animation_play: AnimationPlayer = $AnimationPlay
@onready var margin_container: MarginContainer = $MarginContainer

func transition_in() -> void:
	animation_play.play("transition_in")

func transition_out() -> void: 
	create_tween().tween_property(margin_container, "scale", Vector2.ZERO, 0.3)
	animation_play.play("transition_out")
	
func transition_to(scene: String) -> void:
	transition_in()
	await transitioned_in
	
	var new_scene = load(scene).instantiate()
	var root = get_tree().get_root()

	root.get_child(root.get_child_count() - 1).free()
	root.add_child(new_scene)
	
	new_scene.load_scene()
	await new_scene.loaded
	
	transition_out()
	await transitioned_out
	
	new_scene.activate()

func on_animation_player_animation_finished(anin_name: String) -> void: 
	if anin_name == "transition_in": 
		animation_play.play("pulse_text")
		await transitioned_in
	elif anin_name == "transition_out": 
		await transitioned_out
		
