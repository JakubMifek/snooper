extends Sprite

onready var house = preload("res://scenes/buildings/house/House.tscn")


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
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
