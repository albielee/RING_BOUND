extends StaticBody2D

export var radius = 50
export var segment_count = 50

func _ready():
	create_circle(segment_count, radius)

func create_circle(s_c,r):
	var lines = []
	for i in range(s_c):
		var line = load("res://Environment/LoopCollider.tscn").instance()
		line.set_filename("")
		line.set_owner(get_tree().get_root())
		add_child(line)

		var pos = transform.origin
		var dir_a = ((2*PI)/s_c)*i
		var dir_b = ((2*PI)/s_c)*(i+1)
		
		line.shape.a = pos + Vector2(r*cos(dir_a),r*sin(dir_a))
		line.shape.b = pos + Vector2(r*cos(dir_b),r*sin(dir_b))
		
		lines.append(line)
	
	#lines[3].queue_free()
	#lines[4].queue_free()
	#lines[5].queue_free()
	#lines[6].queue_free()
		
func _physics_process(delta):
	turn(-0.04)
	pass

func turn(speed):
	rotate(speed)
