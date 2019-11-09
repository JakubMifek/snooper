extends ProgressBar

var cooldown_total = 5
var cooldown_left = -1

export var sound_length = 1.0

func _ready():
	value = 100
	rect_position.x = OS.window_size.x - rect_size.x - 20
	rect_position.y = OS.window_size.y - rect_size.y - 20

func reset_cooldown(time_ms):
	cooldown_total = (time_ms + sound_length)
	cooldown_left = (time_ms + sound_length)

func _process(delta):
	if cooldown_left < 0:
		return
	cooldown_left = cooldown_left - delta
	var ratio = (cooldown_total - cooldown_left) / cooldown_total
	value = ratio * 100
