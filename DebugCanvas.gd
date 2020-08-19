extends CanvasLayer
onready var FPS = $FPSReadout;
onready var Process = $ProcessReadout;
onready var object = $ObjectReadout;

func _process(delta):
	var fpsText = str(Performance.get_monitor(Performance.TIME_FPS));
	var processText = str(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS));
	var objectText = str(Performance.get_monitor(Performance.OBJECT_NODE_COUNT));
	FPS.text = fpsText;
	Process.text = processText;
	object.text = objectText;
	pass
