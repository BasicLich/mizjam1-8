extends Node2D

var SPEED = 30
var SCALE_FACTOR = Vector2(1.5, 1.2)

# must be "perfect", "great", good", or "miss"
var type = null
var message = null
var timer = null


func _ready():
	message = get_node(type)
	message.visible = true
	
	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 0.4
	timer.connect("timeout", self, "destroy")
	add_child(timer)


func _process(delta):
	message.scale = message.scale.linear_interpolate(SCALE_FACTOR, SPEED * delta)


func destroy():
	self.queue_free()
