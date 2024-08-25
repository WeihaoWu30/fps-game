extends MeshInstance3D

@onready var animation  = $AnimationPlayer as AnimationPlayer
#@onready var bullet_spawn_point = $Pivot/BulletSpawn
#@onready var bullet = preload("res://bullet.tscn")
#@export var bullet_velocity = 25
#
var bullets = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("shoot") and bullets > 0:
		$"../../../..".spawn_bullet()
		bullets-=1
		animation.speed_scale = 10
		animation.play("recoil")
	elif Input.is_action_pressed("reload") and bullets < 10:
		if not animation.is_playing():
			animation.speed_scale = 2
			animation.play("reload")


			
func _on_animation_finished(animation_name : String):
	if animation_name == "reload":
		bullets = 10
		print("reload")

	
	
	

