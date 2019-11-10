extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t
var animation

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _remove():
	get_parent().remove_child(self)

func play():
	self.t.connect("timeout", self, '_remove')
	self.t.start(0.6)
	self.animation.play('die')

func init(position):
	self.position = position
	self.position[1] += 16
	self.animation = get_node("AnimationPlayer")
	self.t = Timer.new()
	self.t.one_shot = true
	add_child(t)