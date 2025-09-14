class_name Arena extends Node3D


# Будет только две тимы!!!!
@export var scoring_surface_team_1 : Array[WallCollider]
@export var scoring_surface_team_2 : Array[WallCollider]

@export var manager : Manager



signal team_score(team_id: int)


func _ready():
	for wall in scoring_surface_team_1:
		wall.body_entered.connect(_team_score_emit.bind(1))
	for wall in scoring_surface_team_2:
		wall.body_entered.connect(_team_score_emit.bind(2))


func _team_score_emit(body: CollisionObject3D, team_id: int) -> void:
	if body is Ball:
		team_score.emit(team_id)
