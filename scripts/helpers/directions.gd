extends Node

enum Direction {
	UP, RIGHT, DOWN, LEFT, DOWN_RIGHT, DOWN_LEFT, UP_RIGHT, UP_LEFT
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

static func direction_four_diagonal(v):
	match direction_vertical(v):
		Direction.DOWN:
			match direction_horizontal(v):
				Direction.RIGHT: return Direction.DOWN_RIGHT
				Direction.LEFT: return Direction.DOWN_LEFT
		Direction.UP:
			match direction_horizontal(v):
				Direction.RIGHT: return Direction.UP_RIGHT
				Direction.LEFT: return Direction.UP_LEFT
