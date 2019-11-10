extends Node2D

var t
var animation


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