class_name SubtitleEntry

var index: int
var start_time: float  # In seconds
var end_time: float    # In seconds
var total_time: float
var text: String

func _init(idx: int, start: float, end: float, txt: String):
	index = idx
	start_time = start
	end_time = end
	total_time = end-start
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
