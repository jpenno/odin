package game

import "core:c"
import "core:math"
import rl "vendor:raylib"


run: bool
player: Player
enemy: Enemy

init :: proc() {
	run = true
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "Odin + Raylib on the web")

	init_textures()

	player = Player {
		Pos   = {300, 300},
		Size  = {textures[.Player].source_rect.width, textures[.Player].source_rect.height},
		speed = 500,
	}
	enemy = Enemy {
		Pos = {500, 500},
	}
}

update :: proc() {
	dt := rl.GetFrameTime()
	player_update(&player, dt)

	draw()
	// Anything allocated using temp allocator is invalid after this.
	free_all(context.temp_allocator)
}

draw :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.GRAY)

	enemy_draw(enemy)
	player_draw(player)


	// x: f64 = f64(player.Pos.x) - f64(rl.GetMouseX())
	// y: f64 = f64(player.Pos.y) - f64(rl.GetMouseY())
	// rotation := math.atan2(x, y) * -57.29578 // Multiplies the angle by -57.295 to convert to degrees

	rl.DrawTexturePro(
		textures[.Enemy].texture,
		textures[.Enemy].source_rect,
		{500, 500, textures[.Enemy].source_rect.width, textures[.Enemy].source_rect.height},
		{textures[.Enemy].source_rect.width / 2, textures[.Enemy].source_rect.height / 2},
		0,
		rl.WHITE,
	)

	rl.EndDrawing()
}

// In a web build, this is called when browser changes size. Remove the
// `rl.SetWindowSize` call if you don't want a resizable game.
parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(c.int(w), c.int(h))
}

shutdown :: proc() {
	rl.CloseWindow()
}

should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		// Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			run = false
		}
	}

	return run
}
