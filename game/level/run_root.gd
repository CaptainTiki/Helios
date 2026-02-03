extends Node3D
class_name RunRoot


@onready var run_state: RunState = %RunState
@onready var block_controller: BlockController = %BlockController
@onready var scoring_controller: ScoringController = %ScoringController
@onready var health_controller: HealthController = %HealthController

var main : MainScene = null

func setup(_main : MainScene) -> void:
	main = _main
	run_state.run_ended.connect(main.show_run_summary)
	health_controller.died.connect(run_state.end_run)
	run_state.update_hud()

func add_score(score_value : float)-> void:
	scoring_controller.add_score(score_value)
	run_state.update_hud()

func damage_player(dmg : float) -> void:
	health_controller.take_damage(dmg)
	run_state.update_hud()
