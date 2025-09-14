class_name Ball extends RigidBody3D


var speed = 0.0
var straight_angle_margin = 0.1


func _ready():
	# linear_velocity = Vector3(1.0, 0.0, 0.0)
	pass

func _physics_process(_delta: float) -> void:
	linear_velocity = linear_velocity.normalized() * speed
	var collision = move_and_collide(linear_velocity)
	if collision:
		var bounce_velocity = linear_velocity.bounce(collision.get_normal()) * 1
		var new_z = CustomMath.unclamp(bounce_velocity.z, -straight_angle_margin, straight_angle_margin)
		bounce_velocity.z = new_z
		linear_velocity = bounce_velocity
	
