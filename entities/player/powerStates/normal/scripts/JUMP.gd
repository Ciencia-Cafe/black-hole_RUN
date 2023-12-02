extends State



func enter(_lastState):

	parent.playback.travel("JUMP")
	
	if parent.running and abs(parent.motion.x) <= 450:
		parent.running = false

func process_state():
	if parent.onWall() and abs(parent.motion.x) > 200:
		return "WALL"
	
	if parent.motion.y > 0:
		return "FALL"

	elif parent.floorDetect.is_colliding():
		if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
			
			if Input.is_action_pressed("run") and parent.running:
				return "TOP_SPEED"
			
			return "RUN"
		
		return "IDLE"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttackTimer == 0:
		return "ATTACK"
	
	return null

func process_physics(_delta):
	parent.jumpBase()
	parent.setAttackSpeed()
	
	var maxSpeed = parent.MAXSPEED
	if parent.running:
		maxSpeed = parent.runningVelocity
	parent.motion.x = parent.moveBase("X", parent.motion.x, maxSpeed)
	
