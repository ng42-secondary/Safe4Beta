extends BaseCensorBox

static var frame_count = -1  # only one node will update the material
static var blur_adjust: float = 0.0
static var blur_dir = true
const base_blur: float = 20.0

func _ready():
	super._ready()
	$TextureRect/TextureRectX.size = $TextureRect.size
	update_back_screen()

func set_blur_radius(radius: float):
	$TextureRect.material.set_shader_parameter("radius", radius)
	$TextureRect/TextureRectX.material.set_shader_parameter("radius", radius)
	
func adjust_blur_sync():
	if(blur_dir):
		blur_adjust += 0.05
		$TextureRect.material.set_shader_parameter("radius", base_blur + blur_adjust)
		$TextureRect/TextureRectX.material.set_shader_parameter("radius", base_blur - blur_adjust)
		if(blur_adjust >= 10):
			blur_dir = false
	else:
		blur_adjust -= 0.05
		$TextureRect.material.set_shader_parameter("radius", base_blur + blur_adjust)
		$TextureRect/TextureRectX.material.set_shader_parameter("radius", base_blur - blur_adjust)
		if(blur_adjust <= -10):
			blur_dir = true
	
func update_back_screen():
	var fc = Engine.get_process_frames()
	if frame_count == fc:
		return
	frame_count = fc
	var current_screen_texture : ImageTexture = BetaData.screen_recorder.get_screen_texture()
	$TextureRect.material.set_shader_parameter("back_screen_texture", current_screen_texture)
	$TextureRect/TextureRectX.material.set_shader_parameter("back_screen_texture", current_screen_texture)
	
func _process(_delta):
	# update material once per frame
	update_back_screen()
	
