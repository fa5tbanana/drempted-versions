extends KinematicBody2D

var velocity = Vector2.ZERO
var mov_axis = Vector2.ZERO
var grav_pull = 700
var onground = 0
var sliding = 0
var flipping = 0
var pounding = 0
var canpound = 1
var wallslide = 0
var justflipped = 0
var energy = 100
var lastwalldir = 0
var storedenergy = 0
var wallroll = 0
var walljumpbuffer = 100


func _process(delta):
	
	
	
	if onground == 1 and mov_axis.x == 0:
		$AnimatedSprite.play("idle")
	elif onground == 1 and not mov_axis.x == 0:
		$AnimatedSprite.play("running")
	else:
		$AnimatedSprite.play("falling")
	
	
	energy = clamp(energy, 0, 100)
	
	
	
	if onground == 1:
		energy = 100
		lastwalldir = 0
	
	if velocity.x < 0:
		$AnimatedSprite.flip_h = 1
	else:
		$AnimatedSprite.flip_h = 0
	
	if not wallslide == 0:
		$AnimatedSprite.play("wall sliding")
	
	if flipping == 1 :
		$flipping.color = Color(1, 0, 0, 1)
		$AnimatedSprite.play("flipping")
	else:
		$flipping.color = Color(1, 1, 1, 1)
	
	if sliding == 1:
		$sliding.color = Color(0, 0, 1, 1)
		$AnimatedSprite.play("sliding")
	else:
		$sliding.color = Color(1, 1, 1, 1)
	
	if justflipped == 1:
		$leap.color = Color(0, 1, 0, 1)
		$AnimatedSprite.play("diving")
	else:
		$leap.color = Color(1, 1, 1, 1)
	
	if pounding == 1:
		$AnimatedSprite.play("pounding")
	
	
	
	pass
	#print(lastwalldir)

func _physics_process(delta):
	gravity(delta)
	
	if $groundcheck.get_overlapping_bodies():
		onground = 1
	else:
		if not $cyote.time_left > 0:
			$cyote.start()
	#check if on ground
	
	wallslide = 0
	
	print(lastwalldir)
	
	if $leftwalldect.get_overlapping_bodies() and pounding == 0 and sliding == 0 and onground == 0 and not mov_axis.x ==0 :
		wallslide = 1
		if lastwalldir== -1:
			energy = 100
			print("cum!!")
		if mov_axis.y < 0:
			velocity.x = -200
			velocity.y -= 15	 * energy * delta
			if energy > 50:
				velocity.y = clamp(velocity.y, -1000, -100 )
			energy -= 200 * delta
	#is touching left wall
	
	if $rightwalldect.get_overlapping_bodies() and pounding == 0 and sliding == 0 and onground == 0 and not mov_axis.x ==0:
		wallslide = -1
		if lastwalldir== 1:
			energy = 100
			print("cum")
		if mov_axis.y < 0:
			velocity.x = 200
			velocity.y -= 15 * energy * delta
			if energy > 50:
				velocity.y = clamp(velocity.y, -1000, -100 )
			energy -= 200 * delta
	#is touching right wall
	
	if not wallslide == 0:
		lastwalldir = wallslide
		print(lastwalldir)
	
	if lastwalldir * velocity.x > 0 and mov_axis.x * lastwalldir > 0 :
		energy += 200 * delta
		
		#print("sslklsljorpll")
	
	if not wallslide == 0:
		#energy += 150 * delta
		pass
	
	print(energy)
	print(lastwalldir)
	
	if onground == 1 and justflipped == 1:
		justflipped = 0
	if not wallslide == 0 and justflipped == 1:
		justflipped = 0
	if velocity.y > 100 and justflipped == 1:
		justflipped = 0
	#ending leaps
	
	mov_axis = getaxis()
	
	if pounding == 1 and onground == 1:
		pounding = 0
		if Input.is_action_pressed("jump"):
			velocity.y = -500
			flipping =1
	#stop pounding on ground 
	
	if not mov_axis.x == 0 and sliding == 0 and flipping == 0:
		$ColorRect.color = Color(0, .25, 1, 1)
	#check if running
	if mov_axis.x == 0 and sliding == 0 and flipping == 0:
		$ColorRect.color = Color(1, 1, 1, 1)
	#check if not running
	
	if Input.is_action_just_pressed("down") and not mov_axis.x == 0 and onground == 1 and sliding ==0 and velocity.x * mov_axis.x > 0:
		sliding = 1
		velocity.x += 400 * mov_axis.x
		$ColorRect.color = Color(0, .5, 0, 1)
	#start sliding
	
	if sliding == 1 and velocity.x < 100 and velocity.x > -100:
		sliding = 0
		print("wewewewewewewewew")
		$ColorRect.color = Color(1, 1, 1, 1)
		
	#stop sliding by going too slow
	
	if sliding == 1 and Input.is_action_just_pressed("jump"):
		sliding = 0
		flipping = 1
		velocity.x += 400 * mov_axis.x
		$ColorRect.color = Color(0, 0, 1, 1)
	#slide hop into flip
	
	if flipping == 1 and Input.is_action_just_pressed("jump") and onground == 0 and wallslide == 0:
		flipping = 0
		velocity.y = -200
		velocity += mov_axis.normalized() * 100
		canpound = 0
		$disable_groundpound.start()
		justflipped = 1
	#jump in air from flipping
	
	if flipping == 1 and onground == 0 and not wallslide == 0:
		flipping = 0
		velocity.y = -200
		velocity += Vector2(-wallslide, .1 * mov_axis.y).normalized() * 300
		canpound = 0
		$disable_groundpound.start()
		justflipped = 1
		velocity.y -= 100
	#wall flip
	
	if pounding == 0:
		if onground == 1 and sliding == 0:
			velocity.x += mov_axis.x * delta * 1000 
		elif onground == 0 and sliding == 0 and lastwalldir == 0:
			velocity.x += mov_axis.x * delta * 350
	#moving speeds for ground and air
	
	if not lastwalldir == 0:
		
		velocity.x += mov_axis.x * delta * 300
		pass
	
	if onground == 1 and sliding == 1:
		velocity.x += mov_axis.x * delta * 200 
	#moving speeds for controling sliding
	
	if mov_axis.x * velocity.x < 0 and onground == 1 and sliding == 0 :
		velocity.x += mov_axis.x * delta * 2000
	#extra speed while turning on ground
	
	if mov_axis.x * velocity.x < 0 and not onground == 1 and sliding == 0 and pounding == 0:
		velocity.x += mov_axis.x * delta * 1300
	#extra speed while turning in air
	
	if onground == 1 and not mov_axis.x == 0 and sliding ==0:
		if velocity.x > 200:
			velocity.x = 200 
		if velocity.x < -200:
			velocity.x = -200
	#clamping speed on ground
	
	if onground == 0 and not mov_axis.x == 0 and sliding == 0 and flipping == 0 and justflipped == 0:
		if velocity.x > 300:
			velocity.x = 300 
		if velocity.x < -300:
			velocity.x = -300
	#clamping speed in air
	
	if onground == 1 and mov_axis.x == 0 and sliding == 0:
		if velocity.x > 0:
			velocity.x += -700 * delta
		if velocity.x < 0:
			velocity.x += 700 * delta
		if velocity.x > -10 and velocity.x < 10:
			velocity.x = 0
	#friction on ground
	
	if sliding == 1:
		if velocity.x > 0:
			velocity.x += -700 * delta
		if velocity.x < 0:
			velocity.x += 700 * delta
		if velocity.x > -10 and velocity.x < 10:
			velocity.x = 0
	#slide friction
	
	if Input.is_action_just_pressed("jump") and onground ==1:
		canpound = 0
		$disable_groundpound.start()
		velocity.y -= 300
		if velocity.x * mov_axis.x < 0:
			flipping = 1
	#jump
	
	if not wallslide == 0 and Input.is_action_just_pressed("jump") and flipping == 0:
			velocity.y /= 2
			velocity.y -= 3 * (100 - energy)
			velocity.x += wallslide * 700
			
	#wall jump
	
	
	
	if Input.is_action_just_released("jump"):
		velocity.y += 50
	#jumping less 
	
	if not wallslide == 0:
		velocity.y = clamp(velocity.y, -10000, 100)
	else:
		velocity.y = clamp(velocity.y, -10000, 600)
	#fall speed clamp
	
	if Input.is_action_just_pressed("jump") and Input.is_action_pressed("down") and sliding == 0 and flipping == 0 and onground == 0 and canpound == 1 and mov_axis.x == 0:
		pounding = 1
		canpound = 0
		$disable_groundpound.start()
		velocity = Vector2(0, 500)
	#ground pound
	
	
	if flipping == 1 and onground == 1 and velocity.y > 0 and Input.is_action_pressed("down") and not mov_axis.x == 0 :
		flipping = 0
		sliding = 1
		velocity.x += 300 * mov_axis.x
		print("war")
		$ColorRect.color = Color(0, .5, 0, 1)
	#slide out of flip
	
	if flipping == 1 and onground == 1 and velocity.y > 0 :
		flipping = 0
		print("warfdfdfdfdfdfdf")
	#land upright out of flip
	
	velocity = move_and_slide(velocity)


func gravity(delta):
	if onground == 0:
		velocity.y += grav_pull * delta 
	pass

func getaxis():
	return(Vector2(int(Input.is_action_pressed("right"))-int(Input.is_action_pressed("left")),int(Input.is_action_pressed("down"))-int(Input.is_action_pressed("up"))))



func _on_disable_groundpound_timeout():
	canpound = 1
	print("warhh???")


func _on_cyote_timeout():
	onground = 0


func _on_rightwalldect_body_shape_entered(body_id, body, body_shape, area_shape):
	if velocity.y > 0 and mov_axis.y < 0 and energy > 50:
		velocity.y = -200


func _on_leftwalldect_body_shape_entered(body_id, body, body_shape, area_shape):
	if velocity.y > 0 and mov_axis.y < 0 and energy > 50:
		velocity.y = -200
