extends State

onready var attackTimer = $attackTimer


var atkDirection := .0

func enter(_lastState):
	parent.snapDesatived = true
	
	parent.setParticle(0, false)
	parent.setParticle(1, false)
	
	var smoke = load("res://objects/dustBlow/dustBlow.tscn").instance()
	smoke.amount = 8
	Global.world.add_child(smoke)
	smoke.lifetime = 0.5
	smoke.preprocess = 0.2
	smoke.global_position = parent.global_position - Vector2(0, 32)
	
	parent.attackComponents[0].monitoring = true
	attackTimer.start()
	
	atkDirection = Input.get_axis("ui_left", "ui_right")
	if atkDirection == 0:
		atkDirection = (1 - (2 * int(parent.fliped)))
	
	parent.fliped = atkDirection < 0
	parent.motion.x = parent.attackVelocity * atkDirection
	parent.gravity = false
	parent.motion.y = 0
	parent.canJump = false
	parent.playback.travel("ATTACK")
	
func process_state():
	if parent.onWall():
		return "WALL"
	
	if attackTimer.is_stopped():
		if not parent.onFloor():
			return "FALL"
		
		if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
			
			if Input.is_action_pressed("run"):
				return "RUN"
		
			return "WALK"
		
		elif parent.motion.x == 0 and Input.get_axis("ui_left", "ui_right") == 0 :
			return "IDLE"

	return null
	
func process_physics(_delta):
	parent.motion.y = 0
	parent.motion.x = parent.attackVelocity * atkDirection


func exit():
	parent.snapDesatived = false
	parent.attackComponents[0].monitoring = false
	parent.gravity = true
	parent.motion.y = 0
	parent.attackDelay.start()
	if not (Input.is_action_pressed("run") and Input.get_axis("ui_left", "ui_right") != 0):
		parent.motion.x /= 2
	else:
		parent.motion.x *= 0.85
