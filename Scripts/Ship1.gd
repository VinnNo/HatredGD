extends RigidBody2D

const bullet1r = preload("res://PlayerBulletRegular.tscn");
#const leftAnalogue = preload("res://LeftAnalogue.tscn");

#Input
var AxisOneVal = Vector2(0,0);
var AxisTwoVal = Vector2(0,0);
var AxisTempVal = Vector2(0,0);
var activeInputOne = 1;
var activeInputTwo = 2;

#Ship
var shipHPMax = 100;
var shipHPCurrent = shipHPMax;

#Engine
var speed = 700;
var BurstSpeed = 1500;
var burstCountCurrent = 0;
var burstCountMax = 2;
var engineDirection = Vector2(0,0);
var engineRotationSpeed = 2;
var preVelocity = Vector2(0,0);
var engineInput = activeInputOne;
var engineAxis = Vector2(0,0);

#Shield
var shieldRotationSpeed = 3;
var shieldDirection = Vector2(0,0);
var collide_bounce = 80;
var shieldDamage = 1;
var shieldInput = 0#activeInputTwo;
var shieldAxis = Vector2(0,0);
var shieldTarget = null;

#Torrent
var torrent1RotationSpeed = 5;
var torrent1Direction = Vector2(0,0);
var torrentBulletDirection = Vector2(0,0);
var torrent1Damage = 0.33;
var torrent1Input = activeInputTwo;
var torrent1Axis = Vector2(0,0);
var torrent1MaxAngle = 106;
var torrentCanShoot = true;
var torrent1Color1 = Color(1, .53, 0, 1);
var torrent1Color2 = Color(0.12, 0.75, 1, 1);
var torrent1Color3 = Color(0.57, 0.27, 1, 1);
var torrent1ColorCurrent = 1;

export var torrentColor1 = Color(1, .53, 0, 1);
export var torrentColor2 = Color(0.12, 0.75, 1, 1);
export var torrentColor3 = Color(0.57, 0.27, 1, 1);
export var torrentColorCurrent = 1;

#var path_to_target;
var target;

func _ready(): 
	pass

func _process(delta):
	var kAction = Input.is_action_just_pressed("ActionOne");
	var kHome = Input.is_action_just_pressed("ui_home");
	if (kAction):
		_Set_Input();
	if (kHome):
		var color = Color(0,0,0,0);
		color = _Set_Torrent_Color(torrent1ColorCurrent);
		$Torrent1Base.modulate = color;
		if (torrent1ColorCurrent == 3):
			torrent1ColorCurrent = 1;
		else:
			torrent1ColorCurrent += 1;
			
	if (engineInput != 0):
		engineAxis = _Get_Input(engineInput)
	if (engineAxis != Vector2(0,0)):
		engineDirection = engineAxis;
		if ($EngineRotation.rotation_degrees != engineDirection.angle()):
			var theta = $EngineRotation.position.angle_to_point(engineDirection)
			$EngineRotation.rotation += sin($EngineRotation.rotation - theta) * engineRotationSpeed * delta
	
	if (shieldInput != 0):
		shieldAxis = _Get_Input(shieldInput);
		if (shieldAxis != Vector2(0,0)):
			shieldDirection = shieldAxis;
			if ($ShieldRotation.rotation_degrees != shieldDirection.angle()):
				var theta = $ShieldRotation.position.angle_to_point(shieldDirection);
				$ShieldRotation.rotation += sin($ShieldRotation.rotation - theta) * shieldRotationSpeed * delta;
	
	if (torrent1Input != 0):
		torrent1Axis = _Get_Input(torrent1Input);
		if (torrent1Axis != Vector2(0,0)):
			torrent1Direction = torrent1Axis;
			torrent1Direction *= -1
			torrentBulletDirection = torrent1Direction;
			if (torrent1Direction.y < 0):
				torrent1Direction.y = 0
			var tempRot = $Torrent1Base/Torrent1Gun.rotation;
			var theta = $Torrent1Base/Torrent1Gun.position.angle_to(torrent1Direction);
			tempRot += sin(tempRot - theta) * torrent1RotationSpeed * delta;
			$Torrent1Base/Torrent1Gun.rotation = tempRot
		#$Torrent1Base/Torrent1Gun.rotation = tempRot;

func _physics_process(delta):
	var kAction = Input.is_action_pressed("ui_accept")
	var kActionPressed = Input.is_action_just_pressed("ui_accept");
	var kAction2 = Input.is_action_pressed("ActionTwo");
	#Engine burst
	if (kActionPressed):
		if (burstCountCurrent < burstCountMax):
			preVelocity = $EngineRotation/Engine.global_position.direction_to($EngineRotation/EngineDirection.global_position);
			preVelocity.x = preVelocity.x * 1 * BurstSpeed
			preVelocity.y = preVelocity.y * 1 * BurstSpeed
			linear_velocity = preVelocity;
			burstCountCurrent += 1;
			$EngineRotation/Engine/EngineBurstParticles.emitting = true;
			$Timers/BurstTimer.start();
	#Regular thrusters
	if kAction:
		preVelocity = $EngineRotation/Engine.global_position.direction_to($EngineRotation/EngineDirection.global_position);
		preVelocity.x = preVelocity.x * 1 * speed * delta
		preVelocity.y = preVelocity.y * 1 * speed * delta
		apply_impulse(Vector2(0,0), preVelocity)
		$EngineRotation/Engine/EngineParticles.emitting = true
	else:
		$EngineRotation/Engine/EngineParticles.emitting = false;
	#Selected turrent Gun
	if (kAction2):
		if (torrentCanShoot):
			var bullet1i = bullet1r.instance();
			$Torrent1Base/Torrent1Gun/Position2D.add_child(bullet1i);
			#var direction = ($Torrent1Base/Torrent1Gun.position - $Torrent1Base/Torrent1Gun/Position2D.position);
			var start = $Torrent1Base/Torrent1Gun.global_position;
			var end = $Torrent1Base/Torrent1Gun/Position2D.global_position;
			var direction = start.direction_to(end)
			bullet1i.dir = direction.normalized();
			bullet1i.modulate = $Torrent1Base.modulate;
			bullet1i._On_Spawn();
			torrentCanShoot = false;
			$Torrent1Base/Torrent1ShotTime.start();
	#Zero Rotation on the ship
	#Physics can actually rotate it, oops
	if (rotation != 0):
		rotation = 0

func _Get_Input(method):
	var kLeft = false;
	var kRight = false;
	var kUp = false;
	var kDown = false;
	
	if (method == 1):
		kLeft = Input.is_action_pressed("AxisOneLeft");
		kRight = Input.is_action_pressed("AxisOneRight");
		kUp = Input.is_action_pressed("AxisOneUp");
		kDown = Input.is_action_pressed("AxisOneDown");
	elif (method == 2):
		kLeft = Input.is_action_pressed("AxisTwoLeft");
		kRight = Input.is_action_pressed("AxisTwoRight");
		kUp = Input.is_action_pressed("AxisTwoUp");
		kDown = Input.is_action_pressed("AxisTwoDown");
		
	var tempAxis = Vector2(0,0)
	
	#   LEFT and RIGHT
	#right
	if (kRight && !kLeft):
		tempAxis.x = 1;
	#left
	if (!kRight && kLeft):
		tempAxis.x = -1;
	#no left or right
	if (!kRight && !kLeft):
		tempAxis.x = 0
	
	#   UP and DOWN
	#up
	if (kUp && !kDown):
		tempAxis.y = -1;
	#down
	if (!kUp && kDown):
		tempAxis.y = 1;
	#no up or down
	if (!kUp && !kDown):
		tempAxis.y = 0;
	
	if (method == 1):
		AxisOneVal = tempAxis;
	elif (method == 2):
		AxisTwoVal = tempAxis;
	
	return tempAxis;
	pass

func _Set_Input():
	if (shieldInput != 0):
		shieldInput = 0;
		torrent1Input = 2;
	elif (torrent1Input != 0):
		torrent1Input = 0;
		shieldInput = 2;

func _Set_Torrent_Color(val):
	if (val == 1):
		return torrent1Color2;
	elif (val == 2):
		return torrent1Color3;
	elif (val == 3):
		return torrent1Color1;
		

func _Do_Hit():
	$AnimationPlayer.play("OnHit");

func _Take_damage(inDamage):
	if (inDamage != 0):
		shipHPCurrent -= inDamage;
		_Do_Hit();

func _on_impact(body):
	pass

func _on_BurstTimer_timeout():
	burstCountCurrent -= 1;
	if burstCountCurrent < 0:
		burstCountCurrent = 0;
	if burstCountCurrent != 0:
		$Timers/BurstTimer.start();
	pass # Replace with function body.


func _on_ParticleBurstTimer_timeout():
	$EngineRotation/Engine/CPUParticles2D.amount = 30;
	$EngineRotation/Engine/CPUParticles2D.emission_sphere_radius = 60
	pass # Replace with function body.

#shield
func _on_Area2D_area_entered(area):
	var pos1 = area.global_position
	var pos2 = global_position;
	var dir = pos1.direction_to(pos2) * 10;
	var dir2 = linear_velocity;
	#dir.x *= collide_bounce;
	#dir.y *= collide_bounce;
	dir *= collide_bounce;
	linear_velocity = dir;
	#_Do_Hit();
	pass 

func _on_area_entered(pos):
	var vel = linear_velocity;
	if (vel.x < 0):
		vel.x *= -1;
	if (vel.y < 0):
		vel.y *= -1;
	var pos2 = global_position;
	var dir = pos.direction_to(pos2) * 10;
	dir *= collide_bounce;
	linear_velocity = dir;
	_Do_Hit();
	pass 


func _on_Torrent1ShotTime_timeout():
	torrentCanShoot = true;
	pass # Replace with function body.
