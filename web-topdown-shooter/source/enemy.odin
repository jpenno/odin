package game
import rl "vendor:raylib"

Enemy :: struct {
	Pos:  rl.Vector2,
	dead: bool,
}

enemy_draw :: proc(e: Enemy) {
	if e.dead {
		return
	}

	texture_draw(.Enemy, e.Pos)
}
