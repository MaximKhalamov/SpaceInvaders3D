uniform float hueShift;
uniform float satFactor;
uniform float valFactor;
uniform sampler2D texture;
varying vec4 vertColor;
varying vec4 vertTexCoord;

vec3 rgb2hsv(vec3 c) {
  float minV = min(min(c.r, c.g), c.b);
  float maxV = max(max(c.r, c.g), c.b);
  float delta = maxV - minV;
  
  vec3 hsv = vec3(0.0, 0.0, maxV);
  
  if (delta != 0.0) {
    hsv.y = delta / maxV;
    if (c.r == maxV)
      hsv.x = (c.g - c.b) / delta;
    else if (c.g == maxV)
      hsv.x = 2.0 + (c.b - c.r) / delta;
    else
      hsv.x = 4.0 + (c.r - c.g) / delta;
    hsv.x = fract(hsv.x / 6.0);
  }  
  return hsv;
}

vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
  vec4 texColor = texture2D(texture, vertTexCoord.st);

  vec3 hsv = rgb2hsv(texColor.rgb);
  hsv.x = fract(hsv.x + hueShift);  
  hsv.y *= satFactor;  
  hsv.z *= valFactor;
  vec3 rgb = hsv2rgb(hsv);
  
  gl_FragColor = vec4(rgb, texColor.a) * vertColor;
}
