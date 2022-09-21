extends Area2D

var car

var is_game_end = false
signal startActivity
signal enable_drag_and_drop(name)
signal end_game


func _ready():
	pass

#Si el car entra en el area entonces comienza el juego
func _on_TreeActivity_body_entered(body):
	if body is Car and not is_game_end:
		car = body
		if body.has_method("stopEngine"):
			body.stopEngine()
		emit_signal("startActivity")
		if body.has_method("moveCamera"):
			var cat_pos = $Cat/CatSprite.get_transform().origin
			body.moveCamera(-cat_pos.x -300,cat_pos.y)
			yield(get_tree().create_timer(1.5), "timeout")
			$CatSFX.play()
			yield(get_tree().create_timer(3.5), "timeout")
			$Ladder.visible = true


#func que se conecta a los objetos que seran DD y recibe la señal
#de que uno encastro, asi activa el siguiente
#emite la señal para activar el DD del siguiente
func _on_embed(name):
	match name:
		"Ladder":
			$FireFighter.visible = true
			emit_signal("enable_drag_and_drop",'FireFighter')
		"Cat":
			$Cat/CatSprite/Control.visible= false
			emit_signal("end_game")
		"FireFighter":
			$Cat/CatDropZone.visible = true
			is_game_end = true
			emit_signal("enable_drag_and_drop",'Cat')

