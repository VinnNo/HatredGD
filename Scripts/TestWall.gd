extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bounciness = 200;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Do_Bounce():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Area2D_body_entered(body):
	if (body.is_in_group("Player")):
		if (body.has_method("_on_area_entered")):
			var pos = global_position;
			body._on_area_entered(pos);
	if (body.is_in_group("Player Bullet")):
		if (body.has_method("_on_area_entered")):
			body._on_area_entered();
			pass
	pass # Replace with function body.
