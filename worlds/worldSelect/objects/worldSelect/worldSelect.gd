extends Area2D

onready var sprite := $WorldSelect
onready var tween := $Tween
onready var CaveWorldButton := $CanvasLayer/Control/margin/panel/list/caveWorld
onready var hud := $CanvasLayer
onready var hudControl := $CanvasLayer/Control
onready var close := $CanvasLayer/Control/margin/close

enum {
	CaveWorld
}

func _ready():
	CaveWorldButton.connect("pressed", self, "selected", [CaveWorld])
	hudControl.modulate = Color.transparent
	hud.visible = false
	close.disabled = true

func selected(id):
	close.disabled = true
	get_parent().selectedWorld = id
	get_parent().exit(id)
	close.disabled = true
	Global.player.moving = true
	
	tween.interpolate_property(hudControl, "modulate", hudControl.modulate, Color.transparent, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func _on_interactBallon_entered():
	sprite.frame = 1

func _on_interactBallon_exitered():
	sprite.frame = 0

func _on_Tween_tween_completed(object, _key):
	if object == hudControl and object.modulate == Color.transparent:
		hud.visible = false

func _on_interactBallon_interacted():
	if hud.visible: return
	close.disabled = false
	Global.player.moving = false
	Global.player.motion = Vector2.ZERO
	
	hud.visible = true
	tween.interpolate_property(hudControl, "modulate", hudControl.modulate, Color.white, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	
func _on_close_pressed():
	if not hud.visible: return
	close.disabled = true
	Global.player.moving = true
	
	tween.interpolate_property(hudControl, "modulate", hudControl.modulate, Color.transparent, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
