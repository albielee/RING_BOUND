extends KinematicBody2D

export var GRAVITY = 1000
export var JUMP_FORCE = 265
export var HIGH_JUMP_FORCE = 460
export var MAX_FALL_SPEED = 300
export var MOVE_SPEED = 300

enum S{
	idle = 0,
	jump = 1,
	high_jump = 2,
	fall = 3,
	transition_right = 4,
	transition_left = 5
}

var LD = [
	Vector2(0,-1), #up
	Vector2(1,0), #right
	Vector2(0,1), #down
	Vector2(-1,0), #left
]

var state = S.idle
var animation = "idle"

#movement
var velocity = Vector2.ZERO
var local_loop = null
var intended_location = LD[0]
var ON_FLOOR = true
var floor_dir = Vector2(0,1)
var old_move_to = Vector2.ZERO

var fall_timer = 0
var MAX_FALL_DIST = 220

onready var environment_node = get_tree().get_root().get_node("World/Environment")
onready var spawn_location = global_transform.origin

func _ready():
	get_local_loop()

func _physics_process(delta):
	#Continually check if on floor
	var fd_bods = $FloorDetector.get_overlapping_bodies()
	ON_FLOOR = len(fd_bods)>0
		
	get_local_loop()
	#Prevent the rest of the code from running if no loop found
	if(local_loop == null):
		return 0
	if(environment_node == null):
		print("No environment node found")
		return 0
		
	#If the player if too far from its local loop - kill them
	if(distance_to(local_loop.global_transform.origin,global_transform.origin)> MAX_FALL_DIST):
		die()
		print("Death by being too far away from the loop")
		
	match state:
		S.idle: idle(delta);
		S.jump: jump(delta);
		S.high_jump: high_jump(delta);
		S.fall: fall(delta)
	
	apply_gravity(delta)

	#Check if colliding with death giver, e.g. spikes and such
	#var bods = 

func distance_to(v1,v2):
	var v_x = v1.x-v2.x
	var v_y = v1.y-v2.y

	return sqrt((v_x*v_x)+(v_y*v_y))

func get_local_loop():
	var min_dist = 999999#large number
	for loop in get_tree().get_nodes_in_group("loop"):
		var dist2loop = distance_to(loop.global_transform.origin,global_transform.origin)
		if(dist2loop < min_dist):
			min_dist = dist2loop
			local_loop = loop
	
func apply_gravity(delta):
	#change the up direction respective of the local gravity well
	velocity.y += GRAVITY*delta*floor_dir.y
	velocity.x += GRAVITY*delta*floor_dir.x
	if(velocity.y > MAX_FALL_SPEED):
		velocity.y = MAX_FALL_SPEED
	if(velocity.x > MAX_FALL_SPEED):
		velocity.x = MAX_FALL_SPEED
func move(delta):
	#Restrict left and right movement, move the character towards its intended location
	var loop_radius = local_loop.radius + 22 #... + player dist
	var loop_origin = local_loop.global_transform.origin
	
	var move_to = loop_origin + intended_location*loop_radius
	var dampener = 20
	
	#Shift towards the move to pos
	#if(move_to.x < transform.origin.x)
	#move_mul = 0
	#var sign_x = sign((loop_origin.x + intended_location.x*local_loop.radius)-transform.origin.x)
	#var sign_y = sign((loop_origin.y + intended_location.y*local_loop.radius)-transform.origin.y)
	#velocity.x += sign_x*local_loop.SPIN_SPEED*loop_radius*floor_dir.y/2
	#velocity.y += sign_y*local_loop.SPIN_SPEED*loop_radius*floor_dir.x/2
	if(ON_FLOOR and environment_node.rotating == false):
		old_move_to = move_to
		#velocity.x += (move_to.x-global_transform.origin.x)*delta*5
		global_transform.origin.x = (move_to.x-global_transform.origin.x)*0.3
	else:
		global_transform.origin.x = (old_move_to.x-global_transform.origin.x)*0.3
		
	look_at(loop_origin+floor_dir*loop_radius*2)
	rotate(-PI/2)
	
	velocity = move_and_slide(velocity, Vector2.ZERO)

func idle(delta):
	move(delta)
	play_animation("idle")
	
	#if something else happens, change state
	if(Input.is_action_just_pressed("jump") and ON_FLOOR):
		state = S.jump
	if(Input.is_action_just_pressed("ui_up") and ON_FLOOR):
		state = S.high_jump
	

func jump(delta):
	move(delta)
	play_animation("jump")
	velocity.y -= JUMP_FORCE*floor_dir.y
	velocity.x -= JUMP_FORCE*floor_dir.x
	print("jumped")
	state = S.idle
	
func high_jump(delta):
	move(delta)
	play_animation("high_jump")
	velocity.y -= HIGH_JUMP_FORCE*floor_dir.y
	velocity.x -= HIGH_JUMP_FORCE*floor_dir.x
	print("high_jumped")
	state = S.idle
	
func fall(delta):
	pass
func rotate_world(dir):
	environment_node.begin_rotation(dir, local_loop.global_transform.origin)
	
##############################################

func play_animation(anim):
	"""
	play_animations(Animation)
	Match animation and play respective animation 
	"""
	
	match anim:
		"idle":
			#play idle anim
			pass

func _on_HurtBox_area_entered(area):
	if(area!=null):
		die()
func die():
	print("DEAD")
	var nodes = get_tree().get_nodes_in_group("resettable")
	for n in nodes:
		n.reset()
func _on_HurtBox_body_entered(body):
	if(body!=null):
		die()

func reset():
	global_transform.origin = spawn_location
	rotation = 0
	state = S.idle
	velocity = Vector2.ZERO
