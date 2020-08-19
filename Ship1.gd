extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 500
var BurstSpeed = 1000
var burstCountCurrent = 0;
var burstCountMax = 2;
var engineDirection = Vector2(0,0)

var preVelocity = Vector2(0,0)

var AxisOneVal = Vector2(0,0)


#var path_to_target;
var target;
const ROTATION_SPEED = 2;

func _ready(): 
	pass

func _process(delta):
	#engineDirection = Vector2(0,0)
	#var vel = Vector2();
	_Get_Input();
	if (AxisOneVal != Vector2(0,0)):
		engineDirection = AxisOneVal;
		if ($EngineRotation.rotation_degrees != engineDirection.angle()):
				var theta = $EngineRotation.position.angle_to_point(engineDirection)
				$EngineRotation.rotation += sin($EngineRotation.rotation - theta) * ROTATION_SPEED * delta

func _physics_process(delta):
	var kAction = Input.is_action_pressed("ui_accept")
	var kActionPressed = Input.is_action_just_pressed("ui_accept");
	if (kActionPressed):
		if (burstCountCurrent < burstCountMax):
			preVelocity = $EngineRotation/Engine.global_position.direction_to($EngineRotation/EngineDirection.global_position);
			preVelocity.x = preVelocity.x * 1 * BurstSpeed
			preVelocity.y = preVelocity.y * 1 * BurstSpeed
			linear_velocity = preVelocity;
			burstCountCurrent += 1;
			$EngineRotation/Engine/EngineBurstParticles.emitting = true;
			$Timers/BurstTimer.start();
	if kAction:
		preVelocity = $EngineRotation/Engine.global_position.direction_to($EngineRotation/EngineDirection.global_position);
		preVelocity.x = preVelocity.x * 1 * speed * delta
		preVelocity.y = preVelocity.y * 1 * speed * delta
		apply_impulse(Vector2(0,0), preVelocity)
		$EngineRotation/Engine/EngineParticles.emitting = true
	else:
		$EngineRotation/Engine/EngineParticles.emitting = false;
	if (rotation != 0):
		rotation = 0
	pass

func _Get_Input():
	var kLeft = Input.is_action_pressed("AxisOneLeft");
	var kRight = Input.is_action_pressed("AxisOneRight");
	var kUp = Input.is_action_pressed("AxisOneUp");
	var kDown = Input.is_action_pressed("AxisOneDown");
	#   LEFT and RIGHT
	#right
	if (kRight && !kLeft):
		AxisOneVal.x = 1;
	#left
	if (!kRight && kLeft):
		AxisOneVal.x = -1;
	#no left or right
	if (!kRight && !kLeft):
		AxisOneVal.x = 0
	
	#   UP and DOWN
	#up
	if (kUp && !kDown):
		AxisOneVal.y = -1;
	#down
	if (!kUp && kDown):
		AxisOneVal.y = 1;
	#no up or down
	if (!kUp && !kDown):
		AxisOneVal.y = 0;

	pass

func _on_impact(body, location):
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
