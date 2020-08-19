extends KinematicBody2D

var hpMax = 3;
var hpCurrent = hpMax;



func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if (body.is_in_group("Player")):
		if (body.has_method("_on_area_entered")):
			var pos = global_position;
			body._on_area_entered(pos);
	if (body.is_in_group("Player Bullet")):
		if (body.modulate == modulate):
			hpCurrent -= 3;
		else:
			hpCurrent -= 0.5;
		if (hpCurrent <= 0):
			queue_free();
		if (body.has_method("_on_area_entered")):
			body._on_area_entered();
			pass


func _on_Area2D_area_entered(area):
	if (area.is_in_group("Player Bullet")):
		print(area)
		if (area.modulate == modulate):
			hpCurrent -= 3;
		else:
			hpCurrent -= 0.5;
		if (area.has_method("_on_area_entered")):
			area._on_area_entered();
