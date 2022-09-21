extends Node2D
export(NodePath) var sprite_path
onready var sprite = get_node(sprite_path)
export(NodePath) var drop_zone_path
onready var drop_zone = get_node(drop_zone_path)
export (NodePath) var drop_sound_path
onready var drop_sound = get_node(drop_sound_path)
export(NodePath) var touch_anim_path
onready var touch_anim = get_node(touch_anim_path)
export(String) var item_name
export(bool) var is_Enable_DD = false
signal embed(name)
var selected = false
var rest_point
var isActivityStart = false
var isEmbed = false

#Area2D para saber si el muse entra en ella se conecta al nodo padre del objeto
func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click") and isActivityStart and is_Enable_DD:
		selected = true
	if Input.is_action_just_released("click"):
		selected = false

#Si el objeto es seleccionado lo movemos a la posicion del mouse (dedo)
#Si lo soltamos se va a la posicion de encastre si ya sucedio
func _physics_process(delta):
	if selected and isActivityStart and not isEmbed:
		sprite.global_position = lerp(sprite.global_position,get_global_mouse_position(),25*delta)
	else:
		if rest_point and isActivityStart:
			sprite.global_position = lerp(sprite.global_position,rest_point,10*delta)

#Si el evento es touch y el objeto esta a 75 de distancia de donde debe encastrar..
#entonces encastra y reproducimos sonid y..
#emitimos la señal al nodo padre tree de que ese objeto encastro 
func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		Input.action_press("click")
	else:
		Input.action_release("click")	
	if event is InputEventScreenTouch and isActivityStart and not isEmbed and is_Enable_DD:
		if not event.pressed:
			selected = false
			var shortest_dist = 75
			var distance = sprite.global_position.distance_to(drop_zone.global_position)
			if distance < shortest_dist:
				rest_point = drop_zone.global_position
				shortest_dist = distance
				if not isEmbed:
					touch_anim.visible = false
					isEmbed = true
					drop_sound.play()
					yield(get_tree().create_timer(0.5), "timeout")
					emit_signal("embed",item_name)

#Func que recibe la señal del nodo padre 
# para que se pueda activar el DD
func _on_enable_drag_and_drop(name):
	if name == item_name:
		is_Enable_DD = true
		touch_anim.visible = true

#func que recibe la señal del nodo padre de que la activida comenzo
func _on_TreeActivity_startActivity():
	isActivityStart = true

