extends Control

var ClickSound
var HoverSound
var ThemeSong

var T_start
var T_credits
var T_exit

var startBtn
var exitBtn
var creditsBtn

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var parent = get_parent()
	ClickSound = parent.get_node('Control').get_node('Control/Click')
	HoverSound = parent.get_node('Control').get_node('Control/Hover')
	ThemeSong = parent.get_node('Control').get_node('Control/Theme')
	
	startBtn = parent.get_node('Control').get_node('Control/StartButton')
	exitBtn = parent.get_node('Control').get_node('Control/ExitButton')
	creditsBtn = parent.get_node('Control').get_node('Control/CreaditsButton')
	
	startBtn.connect("mouse_entered", self, "_play_hover_sound");
	exitBtn.connect("mouse_entered", self, "_play_hover_sound");
	creditsBtn.connect("mouse_entered", self, "_play_hover_sound");
	
	T_start = Timer.new()
	add_child(T_start)
	T_start.wait_time = 1.5
	T_start.one_shot = true
	T_start.connect("timeout", self, "_start_game");
	
	T_credits = Timer.new()
	add_child(T_credits)
	T_credits.wait_time = 1.5
	T_credits.one_shot = true
	T_credits.connect("timeout", self, "_open_credits");
	
	T_exit = Timer.new()
	add_child(T_exit)
	T_exit.wait_time = 1.5
	T_exit.one_shot = true
	T_exit.connect("timeout", self, "_exit_game");
	
	var T = Timer.new()
	add_child(T)
	T.wait_time = 0.15
	T.one_shot = true
	T.connect("timeout", self, "_play_theme_song");
	T.start()

func _play_theme_song():
	ThemeSong.play();

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

func _start_game():
	get_tree().change_scene("res://scenes/Game.tscn")
	
func _open_credits():
	get_tree().change_scene("res://scenes/menu/Credits.tscn")
	
func _exit_game():
	get_tree().quit()
	
func _play_hover_sound():
	if !startBtn.disabled:
		HoverSound.play();
	
func _on_any_btn_click():
	startBtn.disabled = true
	creditsBtn.disabled = true
	exitBtn.disabled = true

func _on_StartButton_button_down():
	ThemeSong.stop()
	_on_any_btn_click()
	ClickSound.play()
	T_start.start()
	get_node("AnimatedSprite").animation = "default"

func _on_CreaditsButton_button_down():
	_on_any_btn_click()
	ClickSound.play()
	T_credits.start()
	get_node("AnimatedSprite").animation = "default"

func _on_ExitButton_button_down():
	ThemeSong.stop()
	_on_any_btn_click()
	ClickSound.play()
	T_exit.start()
	get_node("AnimatedSprite").animation = "default"
