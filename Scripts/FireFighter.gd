extends StaticBody2D

var isWaterOpen = false
#AGREGAR QUE NO FUNCIONE EL CLICK SI NO HAY FUEGO QUE APAGAR

#process_material -0.082 0.05
func _physics_process(delta):
	if Input.is_action_pressed("click") and isWaterOpen:
		if get_global_mouse_position().x > global_position.x:
			$Water.emitting = true;
			if not $WaterSFX.playing:
				$WaterSFX.play()
			look_at(get_global_mouse_position());
	if Input.is_action_just_released("click"):
		if $WaterSFX.playing:
				$WaterSFX.stop()

func helpAction():
	$OhNoSFX.play()
	yield(get_tree().create_timer(5), "timeout")
	isWaterOpen = true
	
	
func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		Input.action_press("click")
	else:
		Input.action_release("click")
