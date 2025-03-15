class_name SRTParser

# Class to represent a subtitle entry
class SubtitleEntry:
	var index: int
	var start_time: float  # In seconds
	var end_time: float    # In seconds
	var text: String
	
	func _init(idx: int, start: float, end: float, txt: String):
		index = idx
		start_time = start
		end_time = end
		text = txt
	
	func _to_string() -> String:
		return "Subtitle #%d [%s --> %s]: %s" % [index, format_time(start_time), format_time(end_time), text]
	
	# Format time as HH:MM:SS,mmm
	func format_time(seconds: float) -> String:
		var hours := int(seconds / 3600)
		var minutes := int(seconds / 60) % 60
		var secs := int(seconds) % 60
		var millisecs := int((seconds - floor(seconds)) * 1000)
		return "%02d:%02d:%02d,%03d" % [hours, minutes, secs, millisecs]

# Parse an SRT file and return an array of SubtitleEntry objects
func parse_srt_file(file_path: String) -> Array[SubtitleEntry]:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Could not open SRT file: " + file_path)
		return []
	
	var content := file.get_as_text()
	file.close()
	
	return _parse_srt_content(content)

# Parse SRT content from a string
func _parse_srt_content(content: String) -> Array[SubtitleEntry]:
	var result: Array[SubtitleEntry] = []
	var lines := content.split("\n")
	var line_index := 0
	
	# Skip empty lines at the beginning
	while line_index < lines.size() and lines[line_index].strip_edges() == "":
		line_index += 1
	
	while line_index < lines.size():
		# Parse index
		var index_str := lines[line_index].strip_edges()
		if index_str == "":
			line_index += 1
			continue
			
		var index := int(index_str)
		line_index += 1
		
		if line_index >= lines.size():
			break
		
		# Parse timestamp
		var timestamp := lines[line_index].strip_edges()
		var timestamp_parts := timestamp.split(" --> ")
		if timestamp_parts.size() != 2:
			push_warning("Invalid timestamp format at line " + str(line_index))
			line_index += 1
			continue
			
		var start_time := parse_timestamp(timestamp_parts[0])
		var end_time := parse_timestamp(timestamp_parts[1])
		line_index += 1
		
		# Parse text
		var text := ""
		while line_index < lines.size() and lines[line_index].strip_edges() != "":
			if text != "":
				text += "\n"
			text += lines[line_index].strip_edges()
			line_index += 1
		
		# Create subtitle entry
		var entry := SubtitleEntry.new(index, start_time, end_time, text)
		result.append(entry)
		
		# Skip empty lines
		while line_index < lines.size() and lines[line_index].strip_edges() == "":
			line_index += 1
	
	return result

# Parse timestamp string (HH:MM:SS,mmm) to seconds
func parse_timestamp(timestamp: String) -> float:
	var parts := timestamp.split(":")
	if parts.size() != 3:
		push_warning("Invalid timestamp format: " + timestamp)
		return 0.0
	
	var hours := int(parts[0])
	var minutes := int(parts[1])
	
	var seconds_parts := parts[2].split(",")
	if seconds_parts.size() != 2:
		push_warning("Invalid seconds format: " + parts[2])
		return 0.0
	
	var seconds := int(seconds_parts[0])
	var millisecs := int(seconds_parts[1] if seconds_parts[0].length() == 3 else seconds_parts[1].pad_zeros(3))
	
	return hours * 3600 + minutes * 60 + seconds + millisecs / 1000.0

# Helper function to find subtitle at a specific time
func get_subtitle_at_time(subtitles: Array[SubtitleEntry], time: float) -> SubtitleEntry:
	for subtitle in subtitles:
		if time >= subtitle.start_time and time <= subtitle.end_time:
			return subtitle
	return null
