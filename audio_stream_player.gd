extends AudioStreamPlayer
@onready var global = Global

func _on_ready():
	self.play()
	$"Momentum 1".play()
	$"Momentum 2".play()
	$"Momentum 3".play()
	
func _physics_process(delta: float) -> void:
	if global.lastSwap != global.currentSong:
		var playback = get_stream_playback() as AudioStreamPlaybackInteractive
		playback.switch_to_clip_by_name(global.currentSong)
		global.lastSwap = global.currentSong
	if not self.playing:
		self.play()
		$"Momentum 1".play()
		$"Momentum 2".play()
		$"Momentum 3".play()
	var momentum = global.player.velocity.length()
	var volumeA = (momentum/10)-20
	if volumeA > 0:
		volumeA = 0
	var volumeB = (momentum/10)-90
	if volumeB > 0:
		volumeB = 0
	var volumeC = (momentum/10)-160
	if volumeC > 0:
		volumeC = 0
	print(str(int(volumeA)) + " " + str(int(volumeB)) + " " + str(int(volumeC)))
	$"Momentum 1".volume_db = volumeA
	$"Momentum 2".volume_db = volumeB
	$"Momentum 3".volume_db = volumeC
