extends Node2D


onready var citizen = preload("res://people/farmer.tscn")

var houses

func _ready():
	houses = get_tree().get_nodes_in_group("houses")

func spawnCitizen():
	var newCitizen = citizen.instance()
	newCitizen.position = houses[0].position
	
	newCitizen.houseLocation = houses[0].position
	newCitizen.occupationLocation = houses[1].position
	
	get_tree().get_root().add_child(newCitizen)