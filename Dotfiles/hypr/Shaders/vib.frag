#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// Barrel distortion strength
const float k1 = 0.22;
const float k2 = 0.05;

// Size of the unwarped border in normalized coords (0–0.5)
const vec2 safeBorder = vec2(0.12, 0.12); // ~12% of width/height untouched
// How soft the blend is between warped and unwarped
const float blendSize = 0.08;

vec2 barrel(vec2 uv, vec2 center) {
    vec2 p = uv - center;
    float r2 = dot(p, p);
    float f = 1.0 + k1 * r2 + k2 * r2 * r2;
    return center + p * f;
}

void main() {
    vec2 uv = v_texcoord;
    vec2 center = vec2(0.5);

    // Distance from safe border (0 inside safe zone, >0 outside)
    vec2 distFromSafe = vec2(
        max(0.0, abs(uv.x - 0.5) - (0.5 - safeBorder.x)),
        max(0.0, abs(uv.y - 0.5) - (0.5 - safeBorder.y))
    );
    float dist = length(distFromSafe) / blendSize;

    // Blend factor: 0 = safe zone, 1 = fully warped
    float mask = clamp(dist, 0.0, 1.0);

    // Apply barrel only outside safe zone
    vec2 uvWarped = barrel(uv, center);
    uv = mix(uv, uvWarped, mask);

    // Clamp to avoid sampling outside
    uv = clamp(uv, vec2(0.0), vec2(1.0));

    fragColor = texture(tex, uv);
}

