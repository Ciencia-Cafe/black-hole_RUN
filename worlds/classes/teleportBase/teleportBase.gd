class_name TeleportBase extends Area2D

export(NodePath) var destinationPath
onready var destination := get_node_or_null(destinationPath)

var warpType := "warp"

export var limitsMin := Vector2(-10000000, -10000000)
export var limitsMax := Vector2(10000000, 10000000)

func teleport():
	if not destination: return
	destination.init()

func init():
	Global.player.global_position = global_position
	Global.world.setCameraLimits(limitsMin + global_position, limitsMax + global_position)
	
	teleportFinish()

func _ready():
	collision_layer = 1024
	collision_mask = 0

func teleportFinish():
	Global.player.visible = true
	Global.player.camera.current = true
	Global.player.moving = true
	Global.player.active = true
