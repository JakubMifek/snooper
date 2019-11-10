extends Control

# Other nodes
var Population
var Cam

# Sounds
var Shots = []
var EmptyClip
var Reload
onready var UpgradeButton = get_node('/root/Root/UI/CanvasLayer2/UpgradeButton')

# Variables
var T
var COOLDOWN_IN_MS = 4.5 * 1000
var can_shoot = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_reload_timeout():
	can_shoot=true

func _on_timeout():
	Reload.play()

func _input(event):
	if Population == null:
		var parent = get_parent()
		var sounds = parent.get_node('CanvasLayer2')
		Shots = [sounds.get_node('Shot_01'),sounds.get_node('Shot_03'),sounds.get_node('Shot_02')]
		EmptyClip = parent.get_node('CanvasLayer2').get_node('Shot_No_Ammo')
		Reload = sounds.get_node('Reload')
		Reload.connect('finished', self, '_on_reload_timeout')

		parent = parent.get_parent()
		Population = parent.get_node('Population')
		Cam = parent.get_node('Camera').get_node('Camera2D')
		
		T = Timer.new()
		add_child(T)
		T.wait_time = COOLDOWN_IN_MS/1000.0
		T.one_shot = true
		T.connect("timeout", self, "_on_timeout")
	
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://scenes/menu/Menu.tscn")
		if event.pressed and event.scancode == KEY_F1 and Stats.can_upgrade():
			Stats.upgrade()
			UpgradeButton.visible = false
	if event is InputEventMouseButton and event.pressed:
		match (event.button_index):
			BUTTON_LEFT:
				# Play sound effect
				if can_shoot:
					Shots[int(rand_range(0, len(Shots)))].play()
					# Kill people
					Population._killCitizens(Cam.position)
					
					# Reloading
					can_shoot=false
					T.start()
					
					get_parent().get_node('CanvasLayer2').get_node('CooldownBar').reset_cooldown(COOLDOWN_IN_MS/1000)
				else:
					EmptyClip.play()
				
			BUTTON_RIGHT:
				if can_shoot:
					print_debug("BUTTON_RIGHT")
			_:
				print_debug("No")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
