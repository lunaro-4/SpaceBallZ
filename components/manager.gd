class_name Manager extends Node


@export var arena: Arena
@export var shoot_point : ShootPoint

var scoring_ball: Ball

func _ready():
	arena.team_score.connect(scored)
	shoot_point.ball_spawned.connect(_set_scoring_ball)
	shoot_point.spawn_ball()



func scored(team_id: int) -> void:
	if team_id == 1:
		print("team 1 scored!")
	elif team_id == 2:
		print("team 2 scored!")
	scoring_ball.queue_free()
	shoot_point.spawn_ball()	

func _set_scoring_ball(ball: Ball) -> void:
	print("scoring_ball set")
	scoring_ball = ball

func bounced(_body) -> void:
	print("Bounced!")
