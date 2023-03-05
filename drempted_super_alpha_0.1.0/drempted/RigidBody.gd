extends RigidBody
var grounded = 0
onready var velocity = Vector3.ZERO

func _process(delta):
	
		velocity += (get_parent().get_node("poliexa").global_transform.origin - global_transform.origin).normalized() * delta * 9000000 / pow(get_parent().get_node("poliexa").global_transform.origin.distance_to(global_transform.origin), 2)
	
