extends Node2D


onready var citizen = preload("res://scenes/citizen/Citizen.tscn")


func spawnCitizen():
	var newCitizen = citizen.instance()
	# newCitizen.position = homeLocations[0]
	
	# print(newCitizen.houseLocation)
	# newCitizen.houseLocation = homeLocations[0]
	# newCitizen.occupationLocation = homeLocations[1]
	
	# get_tree().get_root().add_child(newCitizen)