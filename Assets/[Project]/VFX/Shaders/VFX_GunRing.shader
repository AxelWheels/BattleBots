// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_GunRing"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_VFX_GunInner_GunOuter("VFX_GunInner_GunOuter", 2D) = "white" {}
		_Outer_Intensity("Outer_Intensity", Range( 0 , 10)) = 1
		_Inner_Intensity("Inner_Intensity", Range( 0 , 10)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	Category 
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane"  }

		
		SubShader
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off

			Pass {
			
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_particles
				#pragma multi_compile_fog


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_OUTPUT_STEREO
				};
				
				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform sampler2D_float _CameraDepthTexture;
				uniform float _InvFade;
				uniform sampler2D _VFX_GunInner_GunOuter;
				uniform float4 _VFX_GunInner_GunOuter_ST;
				uniform float _Inner_Intensity;
				uniform float _Outer_Intensity;

				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord,_MainTex);
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float2 uv_VFX_GunInner_GunOuter = i.texcoord * _VFX_GunInner_GunOuter_ST.xy + _VFX_GunInner_GunOuter_ST.zw;
					float4 tex2DNode1 = tex2D( _VFX_GunInner_GunOuter, uv_VFX_GunInner_GunOuter );
					

					fixed4 col = ( ( i.color * ( ( tex2DNode1.r * _Inner_Intensity ) + ( tex2DNode1.g * _Outer_Intensity ) ) ) * i.color.a );
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
2692;506;1722;915;1337.107;474.0279;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;4;-980.1631,-242.4806;Float;False;Property;_Inner_Intensity;Inner_Intensity;2;0;Create;True;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1124.161,-143.4806;Float;True;Property;_VFX_GunInner_GunOuter;VFX_GunInner_GunOuter;0;0;Create;True;e2827d94f23e48941bcb1c3de58f0ab2;e2827d94f23e48941bcb1c3de58f0ab2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-971.1631,122.5194;Float;False;Property;_Outer_Intensity;Outer_Intensity;1;0;Create;True;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-681.1631,29.51948;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-681.1631,-130.4806;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-525.1623,-40.48055;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;8;-622.163,-329.4806;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-373.1621,-121.4806;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-224.032,-81.64996;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_GunRing;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;2;SrcAlpha;OneMinusSrcAlpha;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;2
WireConnection;3;1;5;0
WireConnection;2;0;1;1
WireConnection;2;1;4;0
WireConnection;6;0;2;0
WireConnection;6;1;3;0
WireConnection;7;0;8;0
WireConnection;7;1;6;0
WireConnection;9;0;7;0
WireConnection;9;1;8;4
WireConnection;0;0;9;0
ASEEND*/
//CHKSM=116145F0975B02588459C2FB97459BC592E075F9