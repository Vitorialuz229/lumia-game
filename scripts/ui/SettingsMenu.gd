extends Control

# Adicionar opções de controlar volume e exibir os comandos do jogo


func _on_BtnBack_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
