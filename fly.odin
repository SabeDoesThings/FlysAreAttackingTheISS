package main

import rl "vendor:raylib"

Fly :: struct {
    tex: rl.Texture2D,
    pos: rl.Vector2,
    speed: f32,
    active: bool,
    bounds: rl.Rectangle,
}