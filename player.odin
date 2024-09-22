package main

import rl "vendor:raylib"

Player :: struct {
    pos: rl.Vector2,
    tex: rl.Texture2D
}

init_player :: proc(p: ^Player) {
    scale_mul: i32 = 6

    p.pos = {300, f32(rl.GetScreenHeight()) / 2}
    p.tex = rl.LoadTexture("assets/player.png")
    p.tex.width *= scale_mul
    p.tex.height *= scale_mul
}

draw_player :: proc(p: ^Player) {
    rl.DrawTextureV(p.tex, p.pos, rl.WHITE)
}

update_player :: proc(p: ^Player) {
    speed: f32 = 200

    if rl.IsKeyDown(.W) {
        p.pos.y -= speed * rl.GetFrameTime()
    }
    if rl.IsKeyDown(.S) {
        p.pos.y += speed * rl.GetFrameTime()
    }

    if p.pos.y <= 0 {
        p.pos.y = 0
    }
    if p.pos.y >= f32(rl.GetScreenHeight()) - f32(p.tex.height) {
        p.pos.y = f32(rl.GetScreenHeight()) - f32(p.tex.height)
    }
}