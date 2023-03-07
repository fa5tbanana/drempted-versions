extends Node2D


func _process(delta):
	
	pass


func _on_Area2D_body_entered(body):
	get_parent().get_node("blinks").makeping()
	queue_free()
