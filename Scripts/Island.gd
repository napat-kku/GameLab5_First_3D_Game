@tool
extends StaticBody3D

# Floating island block: walkable grass top, dirt body and a rocky point underneath.
# Collision matches `size`; the rock underneath is decoration only.

# ---------- VARIABLES ---------- #

@export var size := Vector3(8, 2, 8):
	set(value):
		size = value
		rebuild()
@export var grass_color := Color(0.42, 0.74, 0.33):
	set(value):
		grass_color = value
		rebuild()
@export var dirt_color := Color(0.56, 0.4, 0.26):
	set(value):
		dirt_color = value
		rebuild()
@export var rock_color := Color(0.52, 0.47, 0.44):
	set(value):
		rock_color = value
		rebuild()
## How far the rock point hangs below the island, relative to its smallest side
@export var rock_depth_ratio := 0.6:
	set(value):
		rock_depth_ratio = value
		rebuild()

const GRASS_THICKNESS := 0.3
const GRASS_OVERHANG := 0.15

# ---------- FUNCTIONS ---------- #

func _ready():
	rebuild()

func rebuild():
	if not is_inside_tree():
		return
	for child in get_children():
		if child.has_meta("generated"):
			remove_child(child)
			child.queue_free()

	var shape := BoxShape3D.new()
	shape.size = size
	var collision := CollisionShape3D.new()
	collision.shape = shape
	add_generated(collision)

	var grass_mesh := BoxMesh.new()
	grass_mesh.size = Vector3(size.x + GRASS_OVERHANG * 2, GRASS_THICKNESS, size.z + GRASS_OVERHANG * 2)
	add_mesh(grass_mesh, grass_color, Vector3(0, size.y / 2 - GRASS_THICKNESS / 2, 0))

	var dirt_mesh := BoxMesh.new()
	dirt_mesh.size = Vector3(size.x, size.y - GRASS_THICKNESS, size.z)
	add_mesh(dirt_mesh, dirt_color, Vector3(0, -GRASS_THICKNESS / 2, 0))

	var depth = max(1.5, min(size.x, size.z) * rock_depth_ratio)
	add_mesh(build_rock_mesh(depth), rock_color, Vector3(0, -size.y / 2, 0))

func add_generated(node: Node3D):
	node.set_meta("generated", true)
	add_child(node)

func add_mesh(mesh: Mesh, color: Color, offset: Vector3):
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	mesh_instance.position = offset
	add_generated(mesh_instance)

# Upside-down frustum from the island's footprint to a small tip
func build_rock_mesh(depth: float) -> ArrayMesh:
	var half_top := Vector2(size.x, size.z) * 0.5 * 0.95
	var half_bottom := half_top * 0.18
	var top := [
		Vector3(-half_top.x, 0, -half_top.y), Vector3(half_top.x, 0, -half_top.y),
		Vector3(half_top.x, 0, half_top.y), Vector3(-half_top.x, 0, half_top.y)]
	var bottom := [
		Vector3(-half_bottom.x, -depth, -half_bottom.y), Vector3(half_bottom.x, -depth, -half_bottom.y),
		Vector3(half_bottom.x, -depth, half_bottom.y), Vector3(-half_bottom.x, -depth, half_bottom.y)]
	var center := Vector3(0, -depth / 2, 0)

	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in 4:
		var j = (i + 1) % 4
		add_face(st, [top[i], top[j], bottom[j], bottom[i]], center)
	add_face(st, [bottom[0], bottom[1], bottom[2], bottom[3]], center)
	return st.commit()

# Adds a flat-shaded quad whose winding and normal face away from `center`
func add_face(st: SurfaceTool, quad: Array, center: Vector3):
	var normal: Vector3 = (quad[1] - quad[0]).cross(quad[2] - quad[0]).normalized()
	var face_center: Vector3 = (quad[0] + quad[1] + quad[2] + quad[3]) / 4.0
	if normal.dot(face_center - center) < 0:
		quad.reverse()
		normal = -normal
	# Godot treats clockwise triangles as front faces, so emit them in reverse
	for index in [0, 2, 1, 0, 3, 2]:
		st.set_normal(normal)
		st.add_vertex(quad[index])
