extends Node

var save_path = "user://savegame.cfg"

func save_game():  
	var config = ConfigFile.new()  
	config.set_value("progresso", "fase_atual", Global.fase_atual)  
	config.set_value("progresso", "orbs_coletados", Global.orbs_coletados)  
	config.set_value("progresso", "checkpoint_puzzle", Global.checkpoint_puzzle)  
	config.save(save_path)  

func load_game():  
	var config = ConfigFile.new()  
	var err = config.load(save_path)  
	if err == OK:
		Global.fase_atual = config.get_value("progresso", "fase_atual")  
		Global.orbs_coletados = config.get_value("progresso", "orbs_coletados")  
		Global.checkpoint_puzzle = config.get_value("progresso", "checkpoint_puzzle")  

func _on_Puzzle_iniciado():  
	Global.checkpoint_puzzle = $Player.position  
	Global.save_game()  

func _on_Player_morreu():  
	$Player.position = Global.checkpoint_puzzle  
