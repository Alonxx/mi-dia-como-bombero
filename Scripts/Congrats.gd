extends CanvasLayer


func _ready():
	pass

func _on_end_game():
	$UI.visible = true
	$UI/NextButton/AnimationPlayer.play("pulse")
	$UI/YAYSFX.play()


func _on_NextButton_button_up():
	$UI.visible = false
