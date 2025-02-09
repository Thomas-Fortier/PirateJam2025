extends Node

## Manages the creation, deletion, and playback of sounds.
## Supports playing multiple instances of the same sound simultaneously.

## Active sounds. (key: Sound, value: Array of AudioStreamPlayers)
var _active_sounds: Dictionary = {}
## Active players to loop.
var _looping_players: Array[Node] = []

func _ready() -> void:
	SettingsManager.music_volume_updated.connect(_on_music_volume_setting_modified)
	SettingsManager.sfx_volume_updated.connect(_on_sfx_volume_setting_modified)
	SettingsManager.master_volume_updated.connect(_on_master_volume_setting_modified)

	_on_music_volume_setting_modified(SettingsManager.music_volume)
	_on_sfx_volume_setting_modified(SettingsManager.sfx_volume)
	_on_master_volume_setting_modified(SettingsManager.master_volume)

func _process(_delta: float) -> void:
	for player in _looping_players:
		if not is_instance_valid(player):
			continue

		if not player.is_playing():
			player.play()

		if player.has_meta("follow_node"):
			var follow_node = player.get_meta("follow_node")
			if is_instance_valid(follow_node):
				player.global_position = follow_node.global_position
			else:
				player.remove_meta("follow_node")  # Clean up invalid references

## Plays a sound.
## @param sound The Sound resource to play.
## @param position The position of the sound (optional).
## @param follow_node The node to follow for spatial sounds (optional).
## @return The created AudioStreamPlayer instance.
func play_sound(sound: Sound, position: Vector3 = Vector3.ZERO, follow_node: Node = null) -> Node:
	var player = _create_audio_stream_player_from_sound(sound, position)
	player.stream = sound.stream
	player.volume_db = linear_to_db(sound.volume * _get_combined_volume_setting(sound.sound_type))
	player.bus = sound.bus
	player.pitch_scale = sound.pitch_scale

	if sound.looping:
		_looping_players.append(player)

	if follow_node:
		player.set_meta("follow_node", follow_node)

	_active_sounds[sound] = _active_sounds.get(sound, [])
	_active_sounds[sound].append(player)

	add_child(player)
	player.play()

	return player

## Creates an AudioStreamPlayer based on the sound's spatial type.
## @param sound The Sound resource.
## @param position The position of the sound.
## @return The AudioStreamPlayer instance.
func _create_audio_stream_player_from_sound(sound: Sound, position: Vector3 = Vector3.ZERO) -> Node:
	match sound.spatial_type:
		Sound.SpatialType.SPATIAL_2D:
			var player = AudioStreamPlayer2D.new()
			player.position = Vector2(position.x, position.y)
			player.attenuation = sound.attenuation
			player.max_distance = sound.max_distance
			return player

		Sound.SpatialType.SPATIAL_3D:
			var player = AudioStreamPlayer3D.new()
			player.transform.origin = position
			player.unit_size = sound.attenuation
			player.max_distance = sound.max_distance
			player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
			return player

		_:
			return AudioStreamPlayer.new()

## Stops a specific sound with optional fade-out.
## @param sound The Sound resource to stop.
## @param fade_out_duration Duration of the fade-out in seconds (optional).
func stop_sound(sound: Sound, fade_out_duration: float = 0.0) -> void:
	if not _active_sounds.has(sound):
		_push_warning("Attempted to stop a sound that isn't active.", sound)
		return

	for player in _active_sounds[sound]:
		if is_instance_valid(player):
			if player in _looping_players:
				_looping_players.erase(player)

			if fade_out_duration > 0.0:
				var tween = create_tween()
				tween.tween_property(player, "volume_db", -80, fade_out_duration)
				tween.connect("finished", Callable(self, "_queue_free_after_fade").bind(player))
			else:
				player.stop()
				player.queue_free()

	_active_sounds.erase(sound)

## Stops all currently playing sounds.
func stop_all_sound() -> void:
	for sound in _active_sounds.keys().duplicate():
		stop_sound(sound)

## Stops all currently playing sound effects.
func stop_all_sfx() -> void:
	_stop_all_by_type(Sound.SoundType.SFX)

## Stops all currently playing music.
func stop_all_music() -> void:
	_stop_all_by_type(Sound.SoundType.MUSIC)

## Pauses a specific sound.
## @param sound The Sound resource to pause.
func pause_sound(sound: Sound) -> void:
	if _active_sounds.has(sound):
		for player in _active_sounds[sound]:
			if is_instance_valid(player):
				player.stream_paused = true
	else:
		_push_warning("Attempted to pause a sound that isn't active.", sound)

## Pauses all currently playing sounds.
func pause_all_sound() -> void:
	for sound in _active_sounds.keys().duplicate():
		pause_sound(sound)

## Pauses all currently playing sound effects.
func pause_all_sfx() -> void:
	_pause_all_by_type(Sound.SoundType.SFX)

## Pauses all currently playing music.
func pause_all_music() -> void:
	_pause_all_by_type(Sound.SoundType.MUSIC)

## Resumes a specific sound.
## @param sound The Sound resource to resume.
func resume_sound(sound: Sound) -> void:
	if _active_sounds.has(sound):
		for player in _active_sounds[sound]:
			if is_instance_valid(player):
				player.stream_paused = false
	else:
		_push_warning("Attempted to resume a sound that isn't active.", sound)

## Resumes all currently paused sounds.
func resume_all_sound() -> void:
	for sound in _active_sounds.keys().duplicate():
		resume_sound(sound)

## Resumes all currently paused sound effects.
func resume_all_sfx() -> void:
	_resume_all_by_type(Sound.SoundType.SFX)

## Resumes all currently paused music.
func resume_all_music() -> void:
	_resume_all_by_type(Sound.SoundType.MUSIC)

## Disables looping for a particular active sound.
## @param sound The Sound resource to disable looping for.
func disable_looping(sound: Sound) -> void:
	if not _active_sounds.has(sound):
		_push_warning("Attempted to disable looping for a sound that isn't active.", sound)

	for player in _active_sounds[sound]:
		if player in _looping_players:
			_looping_players.erase(player)

## Updates the volume of all active sounds based on the specified sound type.
## @param new_value The new volume value.
## @param sound_type The type of sound.
func _update_volume(new_value: float, sound_type: Sound.SoundType) -> void:
	for sound: Sound in _active_sounds.keys():
		if sound.sound_type != sound_type:
			continue

		for player in _active_sounds[sound]:
			if is_instance_valid(player):
				player.volume_db = linear_to_db(sound.volume * new_value * SettingsManager.master_volume)

## Handles volume changes when music volume is modified.
## @param new_value The new music volume value.
func _on_music_volume_setting_modified(new_value: float) -> void:
	_update_volume(new_value, Sound.SoundType.MUSIC)

## Handles volume changes when SFX volume is modified.
## @param new_value The new SFX volume value.
func _on_sfx_volume_setting_modified(new_value: float) -> void:
	_update_volume(new_value, Sound.SoundType.SFX)

## Handles volume changes when master volume is modified.
## @param new_value The new master volume value.
func _on_master_volume_setting_modified(new_value: float) -> void:
	for sound in _active_sounds.keys():
		for player in _active_sounds[sound]:
			if is_instance_valid(player):
				player.volume_db = linear_to_db(sound.volume * _get_corresponding_volume_setting(sound.sound_type) * new_value)

## Handles cleanup when a sound finishes playing.
## @param sound The Sound resource that finished playing.
## @param player The AudioStreamPlayer instance that finished playing.
func _on_audio_finished(sound: Sound, player: AudioStreamPlayer) -> void:
	if _active_sounds.has(sound):
		_active_sounds[sound].erase(player)
		if _active_sounds[sound].is_empty():
			_active_sounds.erase(sound)

	if player in _looping_players:
		_looping_players.erase(player)

	if is_instance_valid(player) and player.is_inside_tree():
		player.queue_free()

## Retrieves the corresponding volume setting based on the sound type.
## @param sound_type The type of sound (SFX or MUSIC).
## @return The volume multiplier.
func _get_corresponding_volume_setting(sound_type: Sound.SoundType) -> float:
	match sound_type:
		Sound.SoundType.SFX:
			return SettingsManager.sfx_volume
		Sound.SoundType.MUSIC:
			return SettingsManager.music_volume
		_:
			return 1.0

## Combines the master volume with the sound type volume.
## @param sound_type The type of sound (SFX or MUSIC).
## @return The combined volume multiplier.
func _get_combined_volume_setting(sound_type: Sound.SoundType) -> float:
	return _get_corresponding_volume_setting(sound_type) * SettingsManager.master_volume

## Stops all sounds of a specific type.
## @param sound_type The SoundType to stop.
func _stop_all_by_type(sound_type: Sound.SoundType) -> void:
	for sound in _active_sounds.keys().duplicate():
		if sound.sound_type == sound_type:
			stop_sound(sound)

## Pauses all sounds of a specific type.
## @param sound_type The SoundType to pause.
func _pause_all_by_type(sound_type: Sound.SoundType) -> void:
	for sound in _active_sounds.keys().duplicate():
		if sound.sound_type == sound_type:
			pause_sound(sound)

## Resumes all sounds of a specific type.
## @param sound_type The SoundType to resume.
func _resume_all_by_type(sound_type: Sound.SoundType) -> void:
	for sound in _active_sounds.keys().duplicate():
		if sound.sound_type == sound_type:
			resume_sound(sound)

## Pushes a warning message related to sound operations.
## @param message The warning message.
## @param sound The Sound resource related to the warning.
func _push_warning(message: String, sound: Sound) -> void:
	var stream_info = sound.stream.resource_path if sound.stream else "Unknown"
	push_warning("%s (Stream: %s)" % [message, stream_info])

## Cleans up an AudioStreamPlayer after fade-out.
## @param player The AudioStreamPlayer instance to free.
func _queue_free_after_fade(player: AudioStreamPlayer) -> void:
	if is_instance_valid(player):
		player.queue_free()
