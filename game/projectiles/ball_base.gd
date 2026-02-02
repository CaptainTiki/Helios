extends CharacterBody3D
class_name BallBase

@export var debug : bool = false
@export_category("Movement")
@export var speed : float = 96


func _physics_process(delta: float) -> void:
	bounce()
	move_and_collide(velocity * delta)


func bounce() -> void:
	var collision_count = get_slide_collision_count()
	if collision_count <= 0:
		return #no need to process if no collisions this frame
	for i in range(collision_count):
		var collision : KinematicCollision3D = get_slide_collision(i)
		var node = collision.get_collider() as Node3D
		var bounced : bool = false
		if not node: continue #if the node is null, skip this loop
		if node and node.is_in_group("collidable"):
			var bounce_dir = velocity.bounce(collision.get_normal())
			bounce_dir.y = 0
			velocity = bounce_dir.normalized() * speed
			bounced = true
		if node and node.is_in_group("block"):
			#now that we've bounced - check if we need to damage
			#TODO: do damage to the node with take_damage() after bouncing
			pass
		if bounced:
			return #don't do more bounces this frame

func launch(_dir : Vector3, _root: Node3D) -> void:
	var dir = _dir.normalized() #make sure this is a direction - not a velocity
	velocity = dir * speed #no accel - we just GO with the ball launch
	reparent(_root)

func destroy() -> void:
	pass
