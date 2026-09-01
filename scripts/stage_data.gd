
class_name Stage_Data extends Resource
 
## wave ทั้งหมดของ stage นี้ เรียงตามลำดับ (wave สุดท้าย = boss ก็ใส่ตรงนี้ได้เลย)
@export var waves: Array[Wave_Data] = []

## map scene ของ stage นี้ — ต้องมีลูกชื่อ "SpawnPoints" (มี Marker2D ข้างใน)
## และลูกชื่อ "PlayerStart" (Marker2D จุดเกิด player)
@export var map_scene: PackedScene
