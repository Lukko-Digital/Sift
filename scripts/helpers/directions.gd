extends Node

enum Direction {
	UP, RIGHT, DOWN, LEFT
}

static func direction_horizontal(v):
	if v.x > 0:
		return Direction.RIGHT
	return Direction.LEFT

static func direction_vertical(v):
	if v.y > 0:
		return Direction.DOWN
	return Direction.UP

static func direction_four_way(v):
	if abs(v.x) > abs(v.y):
		# Left Right
		if v.x > 0:
			return Direction.RIGHT
		return Direction.LEFT
	# Up Down
	if v.y > 0:
		return Direction.DOWN
	return Direction.UP
