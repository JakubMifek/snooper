extends Node2D

var t
var animation


func _remove():
	get_parent().remove_child(self)

func play():
	self.t.connect("timeout", self, '_remove')
	self.t.start(0.2)
	self.animation.play('play')

func init(position):
	self.position = position
	self.position[1] -= 14
	self.position[0] += 2
	self.z_index = 1
	self.animation = get_node("AnimationPlayer")
	self.t = Timer.new()
	self.t.one_shot = true
	add_child(t)