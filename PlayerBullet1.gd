extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 1200;
var dir = Vector2(0,0)
var preVelocity = Vector2(0,0);


# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = dir * speed * 10
	pass # Replace with function body.

func _On_Spawn():
	var temptrans = global_transform;
	var scene = get_tree().current_scene;
	get_parent().remove_child(self);
	scene.add_child(self);
	global_transform = temptrans;

func _physics_process(delta):
	if (linear_velocity == Vector2(0,0)):
		linear_velocity = dir * speed
	preVelocity = dir * speed * delta;
	apply_impulse(Vector2(0,0), preVelocity)
	#add_force(Vector2(0,0), preVelocity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RigidBody2D_body_entered(body):
	queue_free();
	pass # Replace with function body.
func _on_area_entered():
	queue_free();
	pass


func _on_body_entered(body):
	queue_free()
	pass # Replace with function body.
