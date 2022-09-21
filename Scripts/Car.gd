extends RigidBody2D

class_name Car

var wheels = []
var speed= 300
#var max_speed = 20
var stopWheels = false
var driving = 0


func _ready():
	wheels = get_tree().get_nodes_in_group("wheel");

func _physics_process(delta):
	driving = 0
	if Input.is_action_pressed("ui_right") and not stopWheels:
		driving += 1
		for wheel in wheels:
			#wheel.angular_velocity = 15
			if wheel.angular_velocity < 15:
				wheel.apply_torque_impulse(speed * delta * 60)
	if driving == 1:
		$EngineSFX.pitch_scale = lerp($EngineSFX.pitch_scale,2,2 * delta)
	else:
		$EngineSFX.pitch_scale = lerp($EngineSFX.pitch_scale,1,2 * delta)

func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		Input.action_press("ui_right")
	else:
		Input.action_release("ui_right")


func _integrate_forces(state):
	if stopWheels:
		for wheel in wheels:
			wheel.linear_velocity = state.linear_velocity.normalized()
			wheel.angular_velocity = 0.0

func stopEngine():
	stopWheels = true;
	$EngineSFX.pitch_scale = lerp($EngineSFX.pitch_scale,1,0)
	yield(get_tree().create_timer(1.5), "timeout")
	$EngineSFX.stop()
	
func moveCamera(x,y):
	var currentZoom = $Camera2D.zoom
	var currentPos = $Camera2D.position
	$Camera2D.smoothing_enabled = true
	$Camera2D.smoothing_speed = 0.7
	$Camera2D.zoom = Vector2(0.5,0.5)
	$Camera2D.position.y = -y 
	$Camera2D.position.x = -x
	yield(get_tree().create_timer(5), "timeout")
	$Camera2D.zoom = currentZoom
	$Camera2D.position = currentPos
	yield(get_tree().create_timer(7), "timeout")
	$Camera2D.smoothing_speed = 5
	$Camera2D.smoothing_enabled = false
	
func startEngine():
	stopWheels = false;
	$EngineSFX.play()


func _on_NextButton_button_up():
	startEngine()
