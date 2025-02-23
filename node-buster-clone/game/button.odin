package game

import rl "vendor:raylib"

Button :: struct {
	pos:  rl.Vector2,
	size: rl.Vector2,
}

buttor_init :: proc(pos: rl.Vector2) -> Button {
	return Button{pos = pos, size = rl.Vector2{200, 50}}
}

button_update :: proc() {

}

button_draw :: proc(b: Button) {
	rl.DrawRectangleV(b.pos, b.size, rl.BLUE)
}
