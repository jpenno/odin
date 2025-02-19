package app

import c "../config"
import rl "vendor:raylib"

Init :: proc() {
	rl.InitWindow(c.SCREEN_WIDTH, c.SCREEN_HEIGHT, "Flappy bird")
	center_window(c.SCREEN_WIDTH, c.SCREEN_HEIGHT)
}

Run :: proc() {
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.GRAY)

		rl.EndDrawing()
	}
}

Quit :: proc() {
	rl.CloseWindow()
}

center_window :: proc(screen_width, screen_height: i32) {
	pos := rl.GetMonitorPosition(rl.GetCurrentMonitor())
	rl.SetWindowPosition(
		i32(pos.x) + rl.GetMonitorWidth(rl.GetCurrentMonitor()) / 2 - screen_width / 2,
		i32(pos.y) + rl.GetMonitorHeight(rl.GetCurrentMonitor()) / 2 - screen_height / 2,
	)
}
