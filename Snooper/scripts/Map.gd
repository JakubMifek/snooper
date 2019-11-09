extends Sprite

onready var house = preload("res://scenes/buildings/house/House.tscn")
onready var citizen = preload("res://scenes/citizen/Citizen.tscn")

const homeLocations = [
	Vector2(0, 0),
	Vector2(200, 100)
]

func _ready():
	for homeLocation in homeLocations:
		var houseObject = house.instance()
		houseObject.position = homeLocation
		var root = get_tree().get_root()
		call_deferred("add_child", houseObject)
		
func spawnCitizen():
	var newCitizen = citizen.instance()
	newCitizen.position = homeLocations[0]
	
	print(newCitizen.houseLocation)
	# newCitizen.houseLocation = homeLocations[0]
	# newCitizen.occupationLocation = homeLocations[1]
	
	get_tree().get_root().add_child(newCitizen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
