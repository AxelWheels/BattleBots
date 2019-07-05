// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Granade_Mat"
{
	Properties
	{
		_Roughness("Roughness", Range( 0 , 1)) = 0.5
		_Colourm("Colourm", Color) = (0.3444219,0.2573529,1,0)
		_Intensity("Intensity", Range( 0 , 10)) = 1
		_Power("Power", Range( 0 , 1)) = 0.9
		_Scale("Scale", Range( 0 , 1)) = 0.9
		_Bias("Bias", Range( 0 , 1)) = 0.1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _Colourm;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float _Intensity;
		uniform float _Roughness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Colourm.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNDotV1 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode1 = ( _Bias + _Scale * pow( 1.0 - fresnelNDotV1, _Power ) );
			o.Emission = ( ( i.vertexColor * ( ( 1.0 - fresnelNode1 ) * _Intensity ) ) * i.vertexColor.a ).rgb;
			o.Smoothness = ( 1.0 - _Roughness );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				fixed4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
2587;460;1722;915;1459.339;378.0156;1.28631;True;True
Node;AmplifyShaderEditor.RangedFloatNode;11;-1163.965,347.6832;Float;False;Property;_Scale;Scale;4;0;Create;True;0.9;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1161.365,261.8832;Float;False;Property;_Bias;Bias;5;0;Create;True;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1169.166,425.6829;Float;False;Property;_Power;Power;3;0;Create;True;0.9;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-850.6589,316.4827;Float;False;Tangent;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;5.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-781.8676,487.1246;Float;False;Property;_Intensity;Intensity;2;0;Create;True;1;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2;-653.0585,320.3831;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;5;-711.5584,88.98305;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-454.5693,349.1062;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-490.3395,82.55158;Float;False;Property;_Roughness;Roughness;0;0;Create;True;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-296.5144,211.1145;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-153.7409,292.1519;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;14;-206.4785,87.62875;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-919.5576,77.2831;Float;False;Constant;_Color1;Color 1;4;0;Create;True;0,0.8758622,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-608.8589,-190.5171;Float;False;Property;_Colourm;Colourm;1;0;Create;True;0.3444219,0.2573529,1,0;0.3444219,0.2573529,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;110.5969,-4.276311;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;VFX_Granade_Mat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;1;10;0
WireConnection;1;2;11;0
WireConnection;1;3;12;0
WireConnection;2;0;1;0
WireConnection;8;0;2;0
WireConnection;8;1;9;0
WireConnection;17;0;5;0
WireConnection;17;1;8;0
WireConnection;15;0;17;0
WireConnection;15;1;5;4
WireConnection;14;0;7;0
WireConnection;0;0;6;0
WireConnection;0;2;15;0
WireConnection;0;4;14;0
ASEEND*/
//CHKSM=E8F27EE8F8B4F7B93F4B29D4AE0B577112CFA33B