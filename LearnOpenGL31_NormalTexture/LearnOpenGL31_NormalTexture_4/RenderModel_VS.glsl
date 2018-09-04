#version 430 core

layout (location = 0) in vec3 _Position;
layout (location = 1) in vec3 _Normal;
layout (location = 2) in vec2 _TexCoord;
layout (location = 3) in vec3 _Tangent;
//layout (location = 4) in vec3 _Bitangent;

out vec2 v2f_TexCoord;
out vec3 v2f_FragPosInTangentSpace;
out vec3 v2f_ViewPosInTangentSpace;
out vec3 v2f_LightPosInTangentSpace;
out vec3 v2f_Normal;

uniform mat4 u_Projection;
uniform mat4 u_View;
uniform mat4 u_Model;
uniform vec3 u_ViewPos;
uniform vec3 u_LightPos = vec3(0.5, 3.5, 0.3);
uniform bool u_IsApplyNormalMap;

void main()
{
	vec4 FragPosInWorldSpace = u_Model * vec4(_Position, 1.0);
	
	gl_Position = u_Projection * u_View * FragPosInWorldSpace;
	v2f_TexCoord = _TexCoord;

	if(u_IsApplyNormalMap)
	{
		mat3 NormalMatrix = mat3(transpose(inverse(u_Model)));
		vec3 T = normalize(NormalMatrix * _Tangent);
		vec3 N = normalize(NormalMatrix * _Normal);
		T = normalize(T - dot(T, N) * N);		//��������TBN����
		vec3 B = normalize(cross(T, N));
		mat3 TBN = mat3(T, B, N);
	
		v2f_FragPosInTangentSpace = TBN * FragPosInWorldSpace.xyz;
		v2f_ViewPosInTangentSpace = TBN * u_ViewPos;
		v2f_LightPosInTangentSpace = TBN * u_LightPos;
	}
	else
	{
		v2f_Normal = _Normal;
		v2f_FragPosInTangentSpace = FragPosInWorldSpace.xyz;
		v2f_ViewPosInTangentSpace = u_ViewPos;
		v2f_LightPosInTangentSpace = u_LightPos;
	}
}