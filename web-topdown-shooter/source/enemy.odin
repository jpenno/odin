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

	rl.DrawTexturePro(
		textures[.Enemy].texture,
		textures[.Enemy].source_rect,
		{
			e.Pos.x,
			e.Pos.y,
			textures[.Enemy].source_rect.width,
			textures[.Enemy].source_rect.height,
		},
		{textures[.Enemy].source_rect.width / 2, textures[.Enemy].source_rect.height / 2},
		0,
		rl.WHITE,
	)
}
