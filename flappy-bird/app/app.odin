package app

import c "../config"
import "../game"
import rl "vendor:raylib"

State :: enum {
	RUNNING,
	PAUSED,
	QUIT,
}

App :: struct {
	state: State,
}

init :: proc() {
	rl.InitWindow(c.SCREEN_WIDTH, c.SCREEN_HEIGHT, "Flappy bird")
	center_window(c.SCREEN_WIDTH, c.SCREEN_HEIGHT)

	game.init()
}

run :: proc() {
	for !rl.WindowShouldClose() {
		update()
		draw()
	}
}

quit :: proc() {
	rl.CloseWindow()
}

@(private)
update :: proc() {
	game.update()
}

@(private)
draw :: proc() {
	rl.BeginDrawing()

	rl.ClearBackground(rl.GRAY)

	game.draw()
	rl.EndDrawing()
}

@(private)
center_window :: proc(screen_width, screen_height: i32) {
	pos := rl.GetMonitorPosition(rl.GetCurrentMonitor())
	rl.SetWindowPosition(
		i32(pos.x) + rl.GetMonitorWidth(rl.GetCurrentMonitor()) / 2 - screen_width / 2,
		i32(pos.y) + rl.GetMonitorHeight(rl.GetCurrentMonitor()) / 2 - screen_height / 2,
	)
}
