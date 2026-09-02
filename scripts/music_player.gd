extends Node

# Autoload (singleton) - ต้อง register ใน Project Settings > Autoload ชื่อ "Music"
# อยู่ข้ามทุก scene เพราะ autoload ไม่โดน free ตอน change_scene_to_file
# เรียกใช้จากที่ไหนก็ได้: Music.play_track(some_stream), Music.stop()

var player: AudioStreamPlayer
var current_stream: AudioStream = null


func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)


# ถ้า stream เดียวกับที่เล่นอยู่แล้ว จะไม่ restart ซ้ำ (กันเพลงกระตุกตอนเรียกซ้ำ)
func play_track(stream: AudioStream, fade_in: float = 0.6) -> void:
	if not stream:
		return
	if stream == current_stream and player.playing:
		return

	# ตั้ง loop = true ที่ตัว resource ตรง ๆ กันไม่ต้องยุ่งกับ import setting
	if "loop" in stream:
		stream.loop = true

	current_stream = stream
	player.stream = stream
	player.volume_db = -80.0
	player.play()

	var tween := create_tween()
	tween.tween_property(player, "volume_db", 0.0, fade_in)


func stop(fade_out: float = 0.6) -> void:
	if not player.playing:
		return

	current_stream = null
	var tween := create_tween()
	tween.tween_property(player, "volume_db", -80.0, fade_out)
	tween.tween_callback(player.stop)
