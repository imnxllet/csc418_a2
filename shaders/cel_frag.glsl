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

uniform vec3 lightPos; // Light position in camera space

void main() {
  // Your solution should go here
  // Only the ambient colour calculations have been provided as an example.

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
    //float u_numShades = 3.0;
     //shadeIntensity = ceil((ambientColor + diffuseColor + specularColor) * u_numShades)/ u_numShades;
    float level;
    if(lambertian > 0.98){
        level = 1.0;
    }else if (lambertian > 0.65) {
        level = 1.0;
    } else if (lambertian > 0.5) {
        level = 0.85;
    } else if (lambertian > 0.05) {
        level = 0.65;
    } else {
        level = 0.45;
    }
    gl_FragColor = vec4(level * (Ka * ambientColor +
                      Kd* lambertian * diffuseColor +
                      Ks * specular*specularColor), 1.0);



  
}