package game

import "core:strings"
import rl "vendor:raylib"

Button :: struct {
	pos:       rl.Vector2,
	size:      rl.Vector2,
	text:      cstring,
	text_size: i32,
	padding:   i32,
}

buttor_init :: proc(
	pos: rl.Vector2,
	text: cstring,
	width: f32 = 200,
	text_size: i32 = 42,
	padding: i32 = 10,
) -> Button {
	return Button {
		size = rl.Vector2{width, f32(text_size + padding)},
		pos = rl.Vector2{pos.x - width / 2, pos.y - (f32(text_size + padding) / 2)},
		text = text,
		text_size = 42,
		padding = padding,
	}
}

button_update :: proc() {

}

button_draw :: proc(b: Button) {
	rl.DrawRectangleV(b.pos, b.size, rl.BLUE)

	ts := rl.MeasureText(b.text, b.text_size)
	x_offset: i32 = i32(b.size.x / 2) - (ts / 2)

	rl.DrawText(
		b.text,
		i32(b.pos.x) + x_offset,
		i32(b.pos.y) + b.padding / 2,
		b.text_size,
		rl.BLACK,
	)
}
