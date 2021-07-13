extends Area2D


onready var direction = 1

var active = true

func _on_ItemRotate_body_entered(body):
	if(active):
		if(body.is_in_group("player")):
			body.rotate_world(direction)
			active = false
			#yada yada, hide sprite, ext..
		

func reset():
	active = true
	#reshow object
