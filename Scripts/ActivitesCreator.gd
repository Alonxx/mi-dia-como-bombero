extends Node2D

var houseOnFire = preload("res://Scenes/House.tscn")
var tree = preload("res://Scenes/Tree.tscn")
var oldActivity = null
var currentActivity = null
onready var congratsLayer = get_node("../CenterContainer/Congrats")
onready var car = get_node("../Car")
var activities = []
var activities_counter = 0

func _ready():
	activities = [houseOnFire,tree]
	spawnActivity()


func spawnActivity():
	if activities_counter > activities.size() - 1:
		activities_counter = 0
	if currentActivity:
		oldActivity = currentActivity
	currentActivity = activities[activities_counter].instance()
	currentActivity.connect("end_game",congratsLayer,'_on_end_game')
	add_child(currentActivity)
	currentActivity.position.x = car.get_transform().origin.x + 3500
	currentActivity.position.y = 440
	activities_counter = activities_counter + 1

func deleteOldActivity():
	if currentActivity:
		currentActivity.free()


func _on_NextButton_button_up():
	deleteOldActivity()
	spawnActivity()
