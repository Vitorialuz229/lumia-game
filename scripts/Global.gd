extends Node

var save_path := "user://savegame.json"
var save_data := {
	"current_level": "vazio",
	"collected_orbs": [],
	"following_orbs": []
}

func register_orb(orb_type: String, position: Vector2):
	# Garante que as arrays existem
	if not save_data.has("collected_orbs"):
		save_data["collected_orbs"] = []
	if not save_data.has("following_orbs"):
		save_data["following_orbs"] = []
	
	# Adiciona apenas se for um novo tipo
	if not orb_type in save_data["collected_orbs"]:
		save_data["collected_orbs"].append(orb_type)
	
	# Adiciona à lista de orbs seguindo
	save_data["following_orbs"].append({
	   		"type": orb_type,
		"x": position.x,
		"y": position.y
	})
	
	save_game()

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))

func load_game() -> bool:
	if !FileAccess.file_exists(save_path):
		return false
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if data is Dictionary:
			save_data = data
			return true
	return false

func reset_save():
	save_data = {
		"current_level": "vazio",
		"collected_orbs": [],
		"following_orbs": []
	}
	save_game()
