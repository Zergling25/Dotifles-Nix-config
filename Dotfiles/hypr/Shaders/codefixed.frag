#version 300 es
precision mediump float;

uniform sampler2D tex;
uniform vec2 screenSize;

#define CURVE_AMOUNT 0.2
#define ZOOM 0.95 // closer to 1.0 = more zoom

out vec4 fragColor;

void main() {
    // Normalized UVs
    vec2 uv = gl_FragCoord.xy / screenSize;

    // Pre-scale inward slightly before distortion
    uv = (uv - 0.5) * ZOOM + 0.5;

    // Barrel distortion
    vec2 cc = uv - 0.5;
    float dist = dot(cc, cc);
    uv += cc * dist * CURVE_AMOUNT;

    // Sample screen
    vec3 col = texture(tex, uv).rgb;

    // Scanlines
    float scan = sin(uv.y * screenSize.y * 1.5);
    col *= 0.85 + 0.15 * scan;

    // Vignette
    float vign = smoothstep(0.9, 0.4, distance(uv, vec2(0.5)));
    col *= vign;

    fragColor = vec4(col, 1.0);
}

