uniform sampler2D envmap;

varying mediump vec2 varyingTexCoord;

const mediump float u_nglReflLevel = 0.25;

const mediump vec4 _LightColor0 = vec4(1.0);

const mediump float _AlphaX = 1.0;
const mediump float _AlphaY = 0.1;

const mediump vec3  _RimColor = vec3(0.7, 0.6, 0.8);
const mediump float _RimIntensity = 0.9;
const mediump vec3  _Brush = vec3(1.0, 0.0, 1.0);

void main()
{     	   	    		     
    mediump vec3 normalDirection = normalize(v_nglNormal);
    mediump vec3 tangentDirection = normalize(cross(normalDirection, _Brush));
    
    mediump vec3 viewDirection = normalize(v_nglVEye);
    mediump vec3 lightDirection = normalize(v_nglVLight);
    mediump float attenuation = v_nglLightLevel;
        
    mediump vec3 halfwayVector = normalize(lightDirection + viewDirection);        
    mediump vec3 binormalDirection = cross(normalDirection, tangentDirection);
    mediump float dotLN = dot(lightDirection, normalDirection);
    
    mediump vec3 ambientLighting = vec3(u_nglAmbientColor);
    mediump vec3 diffuseReflection = attenuation * vec3(_LightColor0) * max(0.0, dotLN);                
    
    // rim lighting
    mediump vec3 rimLighting = pow(1.0 - dot(normalDirection, viewDirection), 2.0) * _RimColor * _RimIntensity;
    
    mediump vec3 specularReflection;
    if (dotLN < 0.0)
    {
        specularReflection = vec3(0.0, 0.0, 0.0); // no specular reflection
    }
    else
    {
        mediump float dotHN = dot(halfwayVector, normalDirection);        
        mediump float dotVN = dot(viewDirection, normalDirection);
        mediump float dotHTAlphaX = dot(halfwayVector, tangentDirection) / _AlphaX;
        mediump float dotHBAlphaY = dot(halfwayVector, binormalDirection) / _AlphaY;
        
        specularReflection = u_nglShininess * attenuation * vec3(u_nglSpecularColor) * sqrt(max(0.0, dotLN / dotVN)) 
        * exp(-2.0 * (dotHTAlphaX * dotHTAlphaX + dotHBAlphaY * dotHBAlphaY) / (1.0 + dotHN));
    }		                
    
    //gamma in
    mediump vec3 sampleColor = vec3(texture2D(u_nglDiffuseMap, varyingTexCoord)); //v_nglTexcoord));
    sampleColor = pow(sampleColor, vec3(2.0));    
    
    // environment
    mediump vec3 bounce = reflect(viewDirection, normalDirection);
    mediump vec2 t = vec2(bounce.x / 2.0 + 0.5, bounce.y / 2.0 + 0.5);
    specularReflection += u_nglReflLevel * pow(vec3(texture2D(envmap, t)), vec3(2.0));
    
    gl_FragColor = vec4(sampleColor * (ambientLighting + diffuseReflection + rimLighting + specularReflection), 1.0);                
    
    //gamma out
    gl_FragColor = pow(gl_FragColor, vec4(1.0 / 2.0));    
}