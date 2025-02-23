package game

Timer_state :: enum {
	DONE,
	IN_PORGRESS,
	RESET,
}

Timer :: struct {
	timer: f32,
	time:  f32,
	state: Timer_state,
}

timer_init :: proc(time: f32) -> Timer {
	return Timer{time = time, timer = time, state = Timer_state.IN_PORGRESS}
}

timer_set_state :: proc(t: ^Timer, state: Timer_state) {
	switch state {
	case .RESET:
		t.timer = t.time
		t.state = .IN_PORGRESS
	case .IN_PORGRESS:
		t.state = .IN_PORGRESS
	case .DONE:
		t.state = .DONE
	}
}

timer_tick :: proc(t: ^Timer, dt: f32) -> Timer_state {
	switch t.state {
	case .RESET:
		t.timer = t.time
		t.state = .IN_PORGRESS
	case .IN_PORGRESS:
		t.timer -= dt
		if t.timer <= 0 {
			t.timer = t.time
			t.state = .DONE
		}
	case .DONE:
		t.state = .IN_PORGRESS
	}

	return t.state
}
