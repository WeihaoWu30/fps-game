extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
	
func _on_body_entered(body: Node3D):
	if body.is_in_group("building"):
		queue_free()
		print("ooga")
