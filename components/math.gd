class_name CustomMath


static func is_in_range(value, _min, _max, _min_strict := false, _max_strict := false) -> bool:
	var is_above_min : bool
	var is_below_max : bool

	if _min_strict:
		is_above_min = value > _min
	else:
		is_above_min = value >= _min
	if _max_strict:
		is_below_max = value < _max
	else: 
		is_below_max = value <= _max

	return is_below_max and is_above_min



## Reverse of buildin [method clamp] function.
## Pushes [value] out of set bounds
static func unclamp(value, _min, _max) -> Variant:
	if !is_in_range(value, _min, _max):
		return value
	var diff_median = (_max - _min) / 2 + _min
	if value == diff_median:
		value -= (randf() - 0.5)
	if value < diff_median:
		return _min
	return _max

	

	
