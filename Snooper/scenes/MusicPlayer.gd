extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var GameStartTracks
var CalmTracks
var SituationalTracks

var AmbientSounds

var PlayFunctions
var T
var T_ambient

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GameStartTracks = [get_node('GameStart01'), get_node('GameStart02')]
	SituationalTracks = [get_node('Situational01'), get_node('Situational02'), get_node('Situational03'), get_node('Situational04'), get_node('Situational05')]
	CalmTracks = [get_node('Calm01'), get_node('Calm02'), get_node('Calm03')]
	AmbientSounds = [get_node("Crow_Caw")]
	_play_start()
	
	T = Timer.new()
	add_child(T)
	T.one_shot = true
	T.connect("timeout", self, "_play_calm_or_situational");
	
	T_ambient = Timer.new()
	add_child(T_ambient)
	T_ambient.one_shot = true
	T_ambient.connect("timeout", self, "_play_ambient_sound");
	T_ambient.wait_time = int(rand_range(10, 30))
	T_ambient.start()

func _play_from_coll(coll):
	coll[int(rand_range(0, len(coll)))].play()
	
func _play_calm():
	_play_from_coll(CalmTracks)
	
func _play_start():
	_play_from_coll(GameStartTracks)

func _play_situational():
	_play_from_coll(SituationalTracks)
	
func _on_audio_track_finished():
	T.wait_time = int(rand_range(12, 50))
	T.start()
	
func _play_calm_or_situational():
	if randi() % 2 == 0:
		_play_calm()
	else:
		_play_situational()
		
func _play_ambient_sound():
	_play_from_coll(AmbientSounds)
	T_ambient.wait_time = int(rand_range(15, 120))
	T_ambient.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
