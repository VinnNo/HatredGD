extends TouchScreenButton


var radius = Vector2(45,45);
var boundary = 100;
var ongoingDrag = -1;
var returnAccel = 20;
export var threshold = 10;



func _input(event):
	if (event is InputEventScreenDrag || (event is InputEventScreenTouch && event.is_pressed())):
		var centerDist = (event.position - get_parent().global_position).length();
		
		print()
		
		if (centerDist <= boundary * global_scale.x || event.get_index() == ongoingDrag):
			set_global_position(event.position - radius * global_scale);
			if (get_button_pos().length() > boundary):
				set_position(get_button_pos() * boundary - radius);
			
			ongoingDrag = event.get_index();
			
	if (event is InputEventScreenTouch && !event.is_pressed() && event.get_index() == ongoingDrag):
		ongoingDrag = -1;
	var stuff = get_value();
	print(stuff)

func get_button_pos():
	return position + radius;

func get_value():
	if (get_button_pos().length() > threshold):
		return get_button_pos().normalized();
	return Vector2(0,0);
