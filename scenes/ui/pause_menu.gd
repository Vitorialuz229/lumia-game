extends Control


func _on_continue_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_exit_pressed() -> void:
	get_tree().paused = false
	Globals.save_game()
	SceneTransition.fade_to_scene("res://scenes/ui/MainMenu.tscn")
	queue_free()
