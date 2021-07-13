extends Node2D

var rotating = false
var dir = 0
var rotate_point = Vector2.ZERO
var rotate_speed = 0.027
var rotate_sum = 0
var target_rotation = 0
var rot_num = 0
var bonus = 0

onready var start_transform = global_transform

func _physics_process(delta):
	if(rotating):
		rotate_world()

func rotate_world():
	rotate_sum += rotate_speed
	rotate(rotate_speed*dir*1.5)
	
	#also rotate camera
	var cam = get_tree().get_root().get_node("World/Camera")
	if(cam != null):
		cam.rotate(dir*rotate_speed)#*bonus)
		
		#rotation = wrapf(rotation, 0, 2*PI)
		#cam.rotation = wrapf(cam.rotation,0,2*PI)
		#if(rotate_sum > PI/2):
		#	bonus -= (rotation-cam.rotation)*0.01
		#else:
		#	bonus += (rotation-cam.rotation)*0.01
		
		
		#if(cam.rotation-rotation < 0):
	#		cam.rotation += rotate_speed
#		else:
#			cam.rotation -= rotate_speed
		#rot_speed += accel*dir*delta
		
		#rotation += rot_speed
		#var world_pos = global_transform.origin
		#var camera_pos = cam.global_transform.origin
		#var rotation_speed = 0.01
		#var wtransform = look_at(Vector2(camera_pos.x,camera_pos.z))
		#var wrotation = Quat(global_transform.basis).slerp(Quat(wtransform.basis), rotation_speed)
		
		#global_transform = Transform(Basis(wrotation), global_transform.origin)
		#cam.rotation += rotate_speed*dir
		#cam.rotation = wrapf(cam.rotation, 0, 2*PI)
		
		#var ang_dif = abs(cam.rotation - target_rotation)
		#print(ang_dif)
		#if(ang_dif > PI):
	#		cam.rotation -= rotate_speed*dir
	#	else:
	#		cam.rotation += rotate_speed*dir
		#cam.rotate(rotate_speed*dir)
	
	
	
	#var world = get_tree().get_root().get_node("World")
	#world.rotate(-rotate_speed*dir)
	#var t = get_tree().get_root().get_node("World")
	#t.rotate(-rotate_speed*dir)
	
	if(rotate_sum > PI):
		rotate_sum = 0
		rotation = target_rotation*1.5
		rotating = false
		if(cam != null):
			cam.rotation = target_rotation

func begin_rotation(d, centre):
	if(rotating == true):
		return null
	rotating = true
	dir = d
	rotate_point = centre
	rot_num += d
	target_rotation = (PI)*rot_num

	var i = 0
	var old_positions = []
	for c in get_children():
		if(c.is_in_group("loop")):
			old_positions.append(c.global_transform.origin)
	global_transform.origin = centre
	for c in get_children():
		if(c.is_in_group("loop")):
			c.global_transform.origin = old_positions[i]
			i+=1

func reset():
	global_transform = start_transform
	rotating = false
	rotate_sum = 0
	rot_num = 0
	dir = 0
	rotate_point = Vector2.ZERO
