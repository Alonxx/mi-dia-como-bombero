extends Area2D

var fires = []
var car = null
var firesIcons = []
signal end_game
var activity_start = false


func _ready():
	for child in get_children():
		if child.is_in_group("fire"):
			fires.push_back(child)
	for child in $FiresIcons.get_children():
		firesIcons.push_back(child)

	
	
func _physics_process(delta):
	pass

func _on_House_body_entered(body):
	if body is Car and not activity_start and not fires.empty():
		activity_start = true
		$FireSFX.play()
		car = body
		$FireFighter.visible = true
		if body.has_method("stopEngine"):
			body.stopEngine()
		if body.has_method("moveCamera"):
			var fighterPos = $FireFighter.get_transform().origin
			body.moveCamera(fighterPos.x,fighterPos.y - 80)
		$FireFighter/FireFighter.helpAction()
		

func _on_Fire_extinct():
	firesIcons[fires.size() - 1].visible = false
	fires.pop_front()
	$ExtinctFireSFX.play()
	if fires.empty():
		$FireFighter.queue_free()
		$FireSFX.stop()
		get_node("CollisionShape2D").disabled = true
		emit_signal("end_game")
		
