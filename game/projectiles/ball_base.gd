extends CharacterBody3D
class_name BallBase

@export var debug : bool = false
@export_category("Movement")
@export var speed : float = 96
@export var max_deflection_angle : float = 60
@export var friction : float = 1.2
@export_category("Damage")
@export var damage : float = 1.0
@export_category("LifeCycle")
@export var max_stability : int = 5
@export var stability_restore : int = 3
@export var collision_exception : float = 0.05
@export var ball_to_ball_multiplier : float = 2.0

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var stability = 0
var launch_timer = 0.1
var collision_exception_body : Node3D = null

func _physics_process(_delta: float) -> void:
	var old_velocity = velocity
	move_and_slide()
	collide(old_velocity)
	
	velocity = velocity.lerp(velocity.normalized() * speed, friction)
	
	if stability < 0:
		destroy()


func collide(old_velocity : Vector3) -> void:
	var collision_count = get_slide_collision_count()
	if collision_count <= 0:
		return #no need to process if no collisions this frame
	for i in range(collision_count):
		var collision : KinematicCollision3D = get_slide_collision(i)
		var node = collision.get_collider() as Node3D
		if not node: continue #if the node is null, skip this loop
		if node.is_in_group("paddle"):
			bounce_off_paddle(collision)
			return
		elif node.is_in_group("block"):
			bounce_off_block(old_velocity, collision)
			return
		elif node.is_in_group("wall"):
			bounce_off_wall(old_velocity, collision)
			return
		elif node.is_in_group("ball"):
			bounce_off_ball(old_velocity, collision)
			return
	#if we get here - we never bounced - but we had a collision. reset the velocity
	velocity = velocity.normalized() * speed

func bounce_off_paddle(collision : KinematicCollision3D) -> void:
	var paddle = collision.get_collider() as Player
	var local_hit = paddle.to_local(collision.get_position())
	var col: CollisionShape3D = paddle.paddle_collider
	var shape : BoxShape3D = col.shape
	var half_width : float = 0.5
	if shape is BoxShape3D: half_width = (shape.size.x * col.global_transform.basis.get_scale().x) * 0.5
	var angle = clamp(local_hit.x / half_width, -1.0, 1.0) * deg_to_rad(max_deflection_angle)
	var x : float = sin(angle)
	var z : float = -cos(angle)
	var return_bounce_dir : Vector3 = Vector3(x, 0, z).normalized()
	velocity = return_bounce_dir * speed
	stability += stability_restore

func bounce_off_wall(old_velocity : Vector3, collision : KinematicCollision3D) -> void:
	var bounce_dir = compute_bounce_dir(old_velocity, collision.get_normal())
	velocity = bounce_dir * speed
	stability -= 1

func bounce_off_ball(old_velocity : Vector3, collision : KinematicCollision3D) -> void:
	var bounce_dir = compute_bounce_dir(old_velocity, collision.get_normal())
	velocity = bounce_dir * (speed * ball_to_ball_multiplier)
	stability += stability_restore * ball_to_ball_multiplier

func bounce_off_block(old_velocity : Vector3, collision : KinematicCollision3D) -> void:
	var bounce_dir = compute_bounce_dir(old_velocity, collision.get_normal())
	velocity = bounce_dir * speed
	stability -= 1
	var node = collision.get_collider() as Node3D
	if node.has_method("take_damage"):
		node.take_damage(damage)

func compute_bounce_dir(old_velocity : Vector3, normal : Vector3) -> Vector3:
	var bounce_dir = old_velocity.bounce(normal)
	bounce_dir.y = 0
	return bounce_dir.normalized()

func stage(paddle : Player) -> void:
	collision_shape_3d.disabled = true
	stability = max_stability
	collision_exception_body = paddle
	add_collision_exception_with(collision_exception_body)

func launch(_dir : Vector3, _root: Node3D) -> void:
	collision_shape_3d.disabled = false
	stability = max_stability
	get_tree().create_timer(collision_exception).timeout.connect(_remove_collision_exception)
	var dir = _dir.normalized() #make sure this is a direction - not a velocity
	velocity = dir * speed #no accel - we just GO with the ball launch
	reparent(_root)

func _remove_collision_exception() -> void:
	remove_collision_exception_with(collision_exception_body)

func destroy() -> void:
	queue_free()
	#TODO: add the ball back to the magazine?
