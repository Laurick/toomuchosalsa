class_name SonParser

# this class will parse the song data with this structure:
# l;12,3;LEFT;PUSH --- left spawn left
# r;2,5;SPACE;HOLD --- right spawn a hold space
# see Constants for reference

# Dictionary[Dictionary[float, String]]
func parse_song(song_name:String) -> Dictionary[String, Dictionary]:
	var file_lines:= read_song_file(song_name)
	var song_parsed:Dictionary[String, Dictionary] = {}
	for line in file_lines:
		if line == "": continue
		var line_data = line.split(";")
		var spawn = line_data[0]
		var time:float = float(line_data[1])
		var type_input:Constants.INPUTS
		match line_data[2]:
			"LEFT":
				type_input = Constants.INPUTS.LEFT
			"RIGHT":
				type_input = Constants.INPUTS.RIGHT
			"UP":
				type_input = Constants.INPUTS.UP
			"DOWN":
				type_input = Constants.INPUTS.DOWN
			"SPACE":
				type_input = Constants.INPUTS.SPACE
		var type:Constants.TYPES
		match line_data[3]:
			"hold":
				type = Constants.TYPES.HOLD
			"push":
				type = Constants.TYPES.PUSH
		var song_input:SongInput = SongInput.new()
		song_input.input = type_input
		song_input.type = type
		if !song_parsed.has(spawn):
			song_parsed[spawn] = {}
		song_parsed[spawn][time] = song_input 
	return song_parsed


func read_song_file(file_path:String) -> PackedStringArray:
	var file_content:String = FileAccess.get_file_as_string(file_path)
	if file_content == "": 
		printerr("Oh no, file not present :( -> %s" % file_path)
		return [] # no file return an empty array
	return file_content.split("\n") # split to get the lines
