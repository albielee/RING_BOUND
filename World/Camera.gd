extends Camera2D

var player = null
var envi = null
export var rot = 0
export var grid_size = 150

var accel = 0.01
var rot_speed = 0

func _ready():
	rotation = rot

func _physics_process(delta):
	player = get_tree().get_root().get_node("World/Player")
	envi = get_tree().get_root().get_node("World/Environment")
	if(player == null or envi == null):
		return null
	
	follow_player_grid(delta)
	#rotate_camera(delta)

func rotate_camera(delta):
	var follow_rot = envi.rotation
	var dir = sign(rotation-follow_rot)
	
	
	


func follow_player_grid(delta):
	var p_t_x = stepify(player.global_transform.origin.x,grid_size)
	var p_t_y = stepify(player.global_transform.origin.y,grid_size)
	var move_weight = 0.1
	transform.origin.x += (p_t_x-transform.origin.x)*move_weight
	transform.origin.y += (p_t_y-transform.origin.y)*move_weight

#func rotate_camera(delta):

func reset():
	player = null
	rotation = rot
	
