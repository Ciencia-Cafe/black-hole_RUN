class_name LevelClass extends Node2D

export var canvasModulateColor := Color.white

var isOnDimension := false
var clock := false
onready var timer := Timer.new()

func _ready():
	timer.one_shot = true
	add_child(timer)
	Global.world = self
	
#	AudioManager.playMusic("paintCaverns")

func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "player", "setCameraLimits", limitsMin, limitsMax)

func _simplesLightToggled(value): 
	Global.canvasModulate.visible = value
	if Global.canvasModulate.visible:
		Global.canvasModulate.set_color(canvasModulateColor)

func setCanvasModulate(color : Color):
	canvasModulateColor = color
	if Global.canvasModulate.visible:
		Global.canvasModulate.set_color(canvasModulateColor)

func loadSave():
	Global.player.active = false
	
	position = Global.save.worldPosition
	Global.player.position = Global.save.player["position"]
	Global.player.set_deferred("active", true)
	
	LoadSystem.closeLoad()

func setupTimer(time):
	clock = true
	timer.wait_time = time
	timer.start()
