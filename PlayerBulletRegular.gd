extends KinematicBody2D

var speed = 1500;
var dir = Vector2(0,0);
var preVelocity = Vector2(0,0);
var Damage = 0;

func _ready():
	pass

func _physics_process(delta):
	preVelocity = dir * speed;
	preVelocity = move_and_slide(preVelocity);
	pass

func _On_Spawn():
	var temptrans = global_transform;
	var scene = get_tree().current_scene;
	get_parent().remove_child(self);
	scene.add_child(self);
	global_transform = temptrans;

func _on_Area_body_entered(body):
	if (!body.is_in_group("Player Bullet")):
		#print(body.get_name())
		queue_free();
	pass
