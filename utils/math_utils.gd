class_name MathUtils
extends RefCounted


## Random point on a circle of given radius around center.
static func random_point_on_circle(center: Vector2, radius: float) -> Vector2:
	var angle := randf() * TAU
	return center + Vector2(cos(angle), sin(angle)) * radius


## Random point inside a circle.
static func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	return random_point_on_circle(center, radius * sqrt(randf()))


## Angle from a to b in radians.
static func angle_between(a: Vector2, b: Vector2) -> float:
	return (b - a).angle()


## Lerp angle (shortest path).
static func lerp_angle_short(from: float, to: float, weight: float) -> float:
	return from + wrapf(to - from, -PI, PI) * weight


## Ease-out cubic.
static func ease_out_cubic(t: float) -> float:
	var u := 1.0 - t
	return 1.0 - u * u * u


## Ease-in-out quad.
static func ease_in_out_quad(t: float) -> float:
	if t < 0.5:
		return 2.0 * t * t
	return 1.0 - (-2.0 * t + 2.0) * (-2.0 * t + 2.0) * 0.5


## Clamp a vector to a max length.
static func clamp_vector(v: Vector2, max_length: float) -> Vector2:
	if v.length_squared() > max_length * max_length:
		return v.normalized() * max_length
	return v


## Check if a point is within a rectangle.
static func point_in_rect(point: Vector2, rect_pos: Vector2, rect_size: Vector2) -> bool:
	return point.x >= rect_pos.x and point.x <= rect_pos.x + rect_size.x \
		and point.y >= rect_pos.y and point.y <= rect_pos.y + rect_size.y
