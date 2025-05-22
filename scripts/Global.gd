extends Node

var save_path := "user://savegame.json"
var save_data := {
	"current_phase": "vazio",
	"orbs_collected": [],
	"puzzle_checkpoint": null,
	"following_orbs_positions": []
}

func _ready():
	if Engine.has_singleton("Window"):
		var window = Engine.get_singleton("Window")
		window.connect("close_request", Callable(self, "_on_about_to_quit"))

func _on_about_to_quit():
	save_game()
	get_tree().quit()

func save_game():
	# Atualiza posições dos orbs antes de salvar
	if has_node("/root/Level/Cynthia"):
		var cynthia = get_node("/root/Level/Cynthia")
		save_data["following_orbs_positions"] = []
		for orb in cynthia.following_orbs:
			if is_instance_valid(orb):
				save_data["following_orbs_positions"].append([orb.global_position.x, orb.global_position.y])

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data)
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
