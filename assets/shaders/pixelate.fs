uniform vec2 pixelSize;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 blockCoords = floor(texture_coords / pixelSize) * pixelSize;

    vec4 pixel = Texel(texture, blockCoords);
    return pixel * color;
}