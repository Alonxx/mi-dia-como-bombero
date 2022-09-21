extends StaticBody2D

var life = 13;
var waterInFire = false

var timerRun = false

signal extinct

func _physics_process(delta):
	if $Fire.amount <= 1 and $Fire.emitting:
		$Fire.emitting= false
		emit_signal("extinct")
		get_node("CollisionShape2D").disabled = true
		$touchHere.visible = false
	if life > 1:
		if $Timer.is_stopped() and waterInFire:
				$Timer.start()
		if Input.is_action_just_released("click"):
			waterInFire = false
			$Timer.stop()
			
			
func startTimer():
	if life > 1:
		if $Timer.is_stopped():
			$Timer.start()
				

func _on_Fire_mouse_entered():
	if life > 1:
		if Input.is_action_pressed("click"):
			if not $WaterOnFireSFX.playing:
				$WaterOnFireSFX.play()
			startTimer()
			waterInFire = true


func _on_Fire_mouse_exited():
	if life > 1:
		waterInFire = false
		$Timer.stop()


func _on_Fire_input_event(viewport, event, shape_idx):
	if life > 1:
		if event is InputEventMouseButton:
			if Input.is_action_pressed("click"):
				startTimer()
			if not $WaterOnFireSFX.playing:
				$WaterOnFireSFX.play()
			waterInFire = true


func _on_Timer_timeout():
	life = life - 4
	$Fire.amount = life;
