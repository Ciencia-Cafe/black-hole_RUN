extends PlayerBase

onready var onWall = $onWall
onready var sprite = $Sprite
onready var animation = $AnimationTree
onready var stateMachine = $StateMachine
onready var playback = animation["parameters/playback"]

func _ready():
	stateMachine.init(self)

func _physics_process(_delta):
	stateMachine.processMachine(_delta)
	_coyoteTimer()
	gravityBase()
	
	sprite.flip_h = fliped
	onWall.cast_to.x = 12 * (1 - 2 * int(fliped))
	animation["parameters/RUN/TimeScale/scale"] = max(0.5, (abs(motion.x) / MAXSPEED) * 3)
	
	motion = move_and_slide(motion, Vector2.UP)

