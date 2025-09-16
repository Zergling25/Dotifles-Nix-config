#version 300 es
precision mediump float;

in vec2 v_texcoord;
out vec4 fragColor;

uniform sampler2D tex;

void main() {
    // Shift coordinates so (0,0) is the center
    vec2 centered = v_texcoord - 0.5;

    // Distance from center
    float r = length(centered);

    // Barrel distortion strength (lower = smoother)
    float k = 0.15; // tweak for more/less distortion

    // Apply smooth barrel distortion
    float factor = 1.0 + k * (r * r); // quadratic curve
    vec2 distorted = centered / factor;

    // Shift back to [0,1] texture space
    distorted += 0.5;

    // If outside bounds, output transparent black
    if (distorted.x < 0.0 || distorted.x > 1.0 ||
        distorted.y < 0.0 || distorted.y > 1.0) {
        fragColor = vec4(0.0);
    } else {
        fragColor = texture(tex, distorted);
    }
}

