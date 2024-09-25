shader_type canvas_item;

// Vignetteのかかり具合.
uniform float vignette_intensity : hint_range(0.0, 10.0) = 0.0;
// Vignetteの透過値.
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;
// Vignetteの色.
uniform vec4 vignette_rgb : source_color = vec4(1.0, 0.0, 0.0, 1.0);
// Vineetteの境界のぼやけ具合 (通常は "vignette_intensity" で調整するけれど念のため作成).
uniform float vinnette_size : hint_range(0.0, 100.0) = 15.0;
// hint_screen_texture で Viewportテクスチャを取得する.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Vignetteの計算.
float vignette(vec2 uv) {
	uv *= 1.0 - uv.xy;
	// 円のグラデーションを作る.
	float vignette = uv.x * uv.y * vinnette_size;
	return pow(vignette, vignette_intensity * vignette_opacity);
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	// "SCREEN_UV" で解像度を考慮した色を取得.
	vec4 color = texture(screen_texture, SCREEN_UV);
	vec4 text = texture(TEXTURE, UV);

	text.rgba *= (vignette_rgb.rgba);
	text.rgba *= (1.0 - vignette(UV));

	COLOR = vec4((text.rgb)*color.rgb,text.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
