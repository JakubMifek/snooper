extends Node2D

func _ready():
	pass

var type = null
var amount = null
var capacity = null

func _init(type, amount, capacity):
	self.type = type
	self.amount = amount
	self.capacity = capacity