extends Node

const SAVE_DATA_PATH = "user://data.json"

func save_data_to_file(data):
	var json_string = to_json(data)
	var file = File.new()
	file.open(SAVE_DATA_PATH, File.WRITE)
	file.store_line(json_string)
	file.close()

func load_data_from_file():
	var file = File.new()
	if not file.file_exists(SAVE_DATA_PATH):
		return { 
			highscore = 0
		}
	file.open(SAVE_DATA_PATH, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	return data
	
