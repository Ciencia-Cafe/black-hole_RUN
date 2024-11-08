extends CanvasLayer

onready var tween = $Tween
onready var transitionPlayer := $transition/AnimationPlayer
onready var backgroundPlayer := $background/AnimationPlayer

func _ready():
	AudioManager.playMusic("recompose")
	Global.roomsToSave.clear()
	Global.dimensionsRooms.clear()

func _input(_event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func transition(show, hide : Array):
	show.current = true
	transitionPlayer.play(show.name)
	yield($transition, "transitionTrigger")
	show.visible = true
	
	for obj in hide:
		obj.current = false
		obj.changed()
		obj.visible = false
	
	backgroundPlayer.play(show.name)
	
	show.enter()
