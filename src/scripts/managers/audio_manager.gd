extends Node

## Plays the given AudioStream at the specified volume and pitch.
func play_sound(sound: AudioStream, volume: float = 1.0, pitch: float = 1.0):
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = sound
	audio_player.volume_db = linear_to_db(volume)
	audio_player.pitch_scale = pitch
	add_child(audio_player)
	audio_player.play()
	
	audio_player.finished.connect(audio_player.queue_free)
