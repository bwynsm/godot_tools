extends Resource


# Instantiate
var noise = OpenSimplexNoise.new()




# Called when the node enters the scene tree for the first time.
func _ready():
	# Configure
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

	# Sample
	print(noise.get_noise_2d(1.0, 1.0))
	
	# This creates a 512x512 image filled with simplex noise (using the currently set parameters)
	var noise_image = noise.get_image(20, 20)
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(noise_image)
	#$Sprite.set_texture(image_texture)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
