vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords)
{
    if (Texel(texture, textureCoords).rgba == vec4(0.0))
    {
        discard;
    }
    return vec4(1.0);
}