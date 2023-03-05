extends KinematicBody

onready var following = get_node("poo")

func _ready():
	
	if get_parent().get_node("dream worm").length == 0:
		following = "dream worm"
	else:
		following = "wormsegment" + str(get_parent().get_node("dream worm").length)
		if get_parent().get_node("dream worm").length == 1:
			following = "wormsegment"
	
func _process(delta):
	
	
	
	
	
	print(following)
	var diswillmove = Vector3(get_parent().get_node(following).global_transform.origin - global_transform.origin)
	if diswillmove.distance_to(Vector3.ZERO) > 2:
		global_transform.origin += diswillmove / 2
	elif diswillmove.distance_to(Vector3.ZERO) > 1:
		global_transform.origin += diswillmove / 4
	pass



