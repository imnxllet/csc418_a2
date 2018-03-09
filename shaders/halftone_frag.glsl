precision mediump float; // It is required to set a floating point precision in all fragment shaders.

// Interpolated values from vertex shader
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // Interpolated view vector

// uniform values remain the same across the scene
uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;
varying highp vec2 texCoordInterp;
uniform vec3 lightPos; // Light position in camera space
// HINT: Use the built-in variable gl_FragCoord to get the screen-space coordinates

void main() {
  // Your solution should go here.
  // Only the ambient colour calculations have been provided as an example.
  //gl_FragColor = vec4(Ka * ambientColor, 1.0);
     vec3 normal = normalize(normalInterp);
    vec3 lightDir = normalize(lightPos - vertPos);
    vec3 reflectDir = reflect(-lightDir, normal);
    vec3 viewDir = normalize(-vertPos);

    float lambertian = max(dot(lightDir,normal), 0.0);
    float specular = 0.0;

    if(lambertian > 0.0) {
       float specAngle = max(dot(reflectDir, viewDir), 0.0);
       specular = pow(specAngle, shininessVal);
    }


      ivec2 halftoneResolution = ivec2(600, 600);
  
  float angle = -45.0;
  float contrastDelta = 0.3; // higher -> grey gets darker
  float brightness = 0.0; // analog for white
  float blackness = 1.1; // higher -> larger areas completely covered by dots
  float smooth = 0.2;
  vec4 dotColor = vec4(0.0, 0.0, 0.0, 1.0);
  vec4 backgroundColor = vec4(Ka * ambientColor +
                      Kd* lambertian * diffuseColor +
                      Ks * specular*specularColor,1.0);
  
  mat2 rotate = mat2(cos(angle), -sin(angle),
                           sin(angle), cos(angle));
  
  mat2 inverse_rotate = mat2(cos(angle), sin(angle),
                                  -sin(angle), cos(angle));

  /* Distance to next dot divided by two. */ 
  vec2 halfLineDist = vec2(1.0)/vec2(halftoneResolution)/vec2(2.0);

  /* Find center of the halftone dot. */
  vec2 center =  rotate * texCoordInterp.st;
  center = floor(center * vec2(halftoneResolution)) / vec2(halftoneResolution);
  center += halfLineDist;
  center = inverse_rotate * center;

 
 // float luminance = new.r;

  /*gl_FragColor = vec4(Ka * ambientColor +
                      Kd* lambertian * diffuseColor +
                      Ks * specular*specularColor, 1.0);*/


  /* Radius of the halftone dot. */
  float radius = sqrt(2.0)*halfLineDist.x*(1.0 - lambertian)*blackness;

  float contrast = 1.0 + (contrastDelta)/(2.0);
  float radiusSqrd = contrast * pow(radius,2.0)
    - (contrastDelta * halfLineDist.x*halfLineDist.x)/2.0
    - brightness * halfLineDist.x*halfLineDist.x;


  vec2 power = pow(abs(center-texCoordInterp.st),vec2(2.0));
  float pixelDist2 = power.x + power.y; // Distance pixel to center squared.

  float delta = smooth*pow(halfLineDist.x,2.0);
  float gradient = smoothstep(radiusSqrd-delta, radiusSqrd+delta, pixelDist2);


  
  gl_FragColor = mix(dotColor, backgroundColor, gradient);
    



}