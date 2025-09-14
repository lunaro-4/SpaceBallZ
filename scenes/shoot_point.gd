extends Marker3D


@export var is_reversed := false

@export var min_y_deviation := 0.0	
@export var max_y_deviation := 0.0	
@export var min_x_deviation := 0.0	
@export var max_x_deviation := 0.0	

var ball = preload("res://scenes/ball.tscn")



func _get_rand_vector() -> Vector3:
	var z_reverse_mult = 1
	if is_reversed: z_reverse_mult *= -1

	var temp_y = max_y_deviation
	max_y_deviation = max(min_y_deviation, max_y_deviation)
	min_y_deviation = min(min_y_deviation, temp_y)

	var temp_x = max_x_deviation
	max_x_deviation = max(min_x_deviation, max_x_deviation)
	min_x_deviation = min(min_x_deviation, temp_x)

	var y_axis_angle := (max_y_deviation- min_y_deviation) *  randf() + min_y_deviation
	var x_axis_angle := (max_x_deviation- min_x_deviation) *  randf() + min_x_deviation


	return Vector3(x_axis_angle, y_axis_angle, z_reverse_mult)

