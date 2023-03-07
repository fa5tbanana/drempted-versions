extends KinematicBody2D

var ping = load("res://ping.tscn")
var max_blinks = 0
var blinks = 0
var velocity = Vector2.ZERO
var distance = 20
var distance_mod = 0
var intensity = 2
var shake = 0
var rot_speed = 10
var heartbeat = 0
var rot_mod  = 0
var coins = 0

onready var pointset = PoolVector2Array()

func _physics_process(delta):
	
	global_position = get_parent().get_node("swordler").global_position
	
	rot_mod += deg2rad(rot_speed * delta * distance / 40)
	
	
	if pointset.empty() :
		pointset.append(Vector2.ZERO)
	


func _process(delta):
	
	if heartbeat < 100:
		heartbeat += 100 * delta
	else:
		heartbeat = 0
	
	distance_mod = sin(PI * heartbeat/50) * intensity
	
	rot_speed = 200 + sin(PI * heartbeat/50) * 400
	
	
	
	
	
	
	pointset = PoolVector2Array()
	for i in blinks:
		pointset.append(Vector2((distance_mod + distance) * cos((i * 2 * PI / blinks)+ rot_mod) + rand_range(-shake,shake), (distance_mod + distance) * sin((i * 2 * PI / blinks)+ rot_mod)+ rand_range(-shake,shake)))						
		
	if blinks > 0:
		pointset.append(pointset[0])
		
		
		$Line2D.points = pointset
		
		
		
		

func pickupcoin():
	coins += 1

func makeping():
	blinks += 1
	distance += 1
	coins += 1
	new_ping(blinks)

func new_ping(segment):
	var instance = ping.instance()
	get_parent().add_child(instance)
	instance.global_transform.origin = global_transform.origin
	instance.segment = segment
