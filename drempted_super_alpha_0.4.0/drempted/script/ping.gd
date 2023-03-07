extends KinematicBody2D

var velocity = Vector2.ZERO
var target = Vector2.ZERO
var segment = 0

func _ready():
	global_position = get_parent().get_node("blinks").global_position
	

func _process(delta):
	pass
#poopoopeepee
func _physics_process(delta):
	target = get_parent().get_node("blinks/Line2D").points[segment-1] + get_parent().get_node("blinks").global_position
	
	velocity = (-global_position + target) * delta * 800
	velocity += get_parent().get_node("swordler").velocity /1.6
	
	move_and_slide(velocity)
	
