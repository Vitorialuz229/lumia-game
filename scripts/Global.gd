extends Node

var save_path = "user://savegame.json"
var save_data = {}

func _ready():
	# Conectar o sinal de fechamento da janela via Window
	if Engine.has_singleton("Window"):
		var window = Engine.get_singleton("Window")
		window.connect("close_request", Callable(self, "_on_about_to_quit"))

func _on_about_to_quit():
	save_game()
	get_tree().quit() # fecha o jogo após salvar

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data)  # método estático correto
		file.store_string(json_string)
		file.close()

func load_game() -> bool:
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var err = json.parse(json_text)
		if err == OK:
			save_data = json.get_data()
			return true
		else:
			push_error("Erro ao parsear JSON: %s" % json.get_error_message())
			return false
	return false
