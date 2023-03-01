extends KinematicBody

var wormseg = load("res://wormsegment.tscn")
var grounded = 1
var mouse_sens = 0.05
var velocity = Vector3.ZERO
onready var length = -1


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rightclick"):
			$xrot/yrot/Head/head.rotate_z(deg2rad(event.relative.y * mouse_sens * 1))
			$xrot/yrot/Head.rotate_y(deg2rad(event.relative.x * mouse_sens * -1))
		else:
			$xrot.rotate_z(deg2rad(event.relative.x * mouse_sens * -1))
			$xrot/yrot.rotate_z(deg2rad(event.relative.y * mouse_sens * -1))



func _process(delta):
	
	if $xrot/yrot/grounded.get_overlapping_bodies():
		grounded = 1
	else:
		grounded = 0
	
	
	if length < 1:
		newseg()
	
	gravity(delta,grounded)
	control(delta)
	ghostdir(delta)
	cam2dirmovement()
	friction()
	
	
	
	
	
	velocity = move_and_slide(velocity)

func gravity(delta, grounded):
	if grounded == 0:
		velocity += (get_parent().get_node("poliexa").global_transform.origin - global_transform.origin).normalized() * delta * 9000000 / pow(get_parent().get_node("poliexa").global_transform.origin.distance_to(global_transform.origin), 2)

func cam2dirmovement():
	pass

func friction():
	if grounded == 1:
		velocity = velocity * .99

func control(delta):
	$xrot/yrot/booster.transform.origin = Vector3.ZERO
	
	if Input.is_action_just_pressed("jump") and $xrot/yrot/canjump.get_overlapping_bodies():
		velocity += (global_transform.origin - $xrot/yrot/pointdir.global_transform.origin)*200
	
	if Input.is_action_just_pressed("right"):
		$xrot/yrot/booster.transform.origin.z += -799
	 
	if Input.is_action_just_pressed("left"):
		$xrot/yrot/booster.transform.origin.z += 799
	
	if Input.is_action_pressed("break"):
		velocity = Vector3.ZERO
	
	
	if Input.is_action_pressed("forwards"):
		$xrot/yrot/booster.transform.origin.x -= 7
		if Input.is_action_pressed("rightclick") == bool(0):
			$xrot/yrot/Head.rotation.y =0
	velocity += (global_transform.origin - $xrot/yrot/booster.global_transform.origin) * 10 *delta 
	

func ghostdir(delta):
	get_parent().get_node("wormghost").global_transform.origin = global_transform.origin
	get_parent().get_node("wormghost").look_at(get_parent().get_node("poliexa").global_transform.origin,$left.global_transform.origin - global_transform.origin)
	if get_parent().get_node("poliexa/Area").get_overlapping_bodies() and $Timer.time_left < .01:
		rotation = ((get_parent().get_node("wormghost").rotation))
		$xrot/yrot.rotation.z = 0
		
	
	if get_parent().get_node("poliexa/Area").get_overlapping_bodies() and $Timer.time_left > .01:
		rotation += ((get_parent().get_node("wormghost").rotation)-rotation)/.2*delta
		$xrot/yrot.rotation.z += (0-$xrot/yrot.rotation.z)
		
		

func newseg():
	length += 1
	var instance = wormseg.instance()
	get_parent().add_child(instance)
	instance.global_transform.origin = global_transform.origin
	
	


func _on_Area_body_entered(body):
	$Timer.start()
	
