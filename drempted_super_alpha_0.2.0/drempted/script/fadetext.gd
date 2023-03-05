extends TextEdit


func _process(delta):
	
	
	if $Area2D.get_overlapping_bodies():
		visible = true
		
		
	else:
		visible = false
	
