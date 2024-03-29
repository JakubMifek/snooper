extends "res://scripts/Building.gd"

var resource = Stats.resources[Stats.RESOURCES.wheat]

func interactWith(citizen, goal):
	.interactWith(citizen, goal)
	
	if goal == Goal.GIVE:
		Stats.add_resource(Stats.RESOURCES.wheat, +citizen.productivity)
		
	elif goal == Goal.TAKE:
		if resource.amount >= citizen.hungryness:
			Stats.add_resource(Stats.RESOURCES.wheat, -citizen.hungryness)
			citizen.lives = min(citizen.lives + 1, citizen.max_lives)
		else:
			citizen.lives -= 1
			if citizen.lives == 0:
				citizen._kill()
