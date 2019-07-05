// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Flash"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Intensity("Intensity", Range( 0 , 20)) = 2
		_VFX_Spots_Clouds_Dot("VFX_Spots_Clouds_Dot", 2D) = "white" {}
		_Float1("Float 1", Range( 0 , 1)) = 0
		_Float0("Float 0", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	Category 
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane"  }

		
		SubShader
		{
			Blend One One
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
				uniform sampler2D _VFX_Spots_Clouds_Dot;
				uniform float4 _VFX_Spots_Clouds_Dot_ST;
				uniform float _Intensity;
				uniform float _Float0;
				uniform float _Float1;

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

					float2 uv_VFX_Spots_Clouds_Dot = i.texcoord * _VFX_Spots_Clouds_Dot_ST.xy + _VFX_Spots_Clouds_Dot_ST.zw;
					float4 tex2DNode8 = tex2D( _VFX_Spots_Clouds_Dot, uv_VFX_Spots_Clouds_Dot );
					float smoothstepResult13 = smoothstep( _Float0 , ( _Float0 + _Float1 ) , ( i.color.a * tex2DNode8.b ));
					

					fixed4 col = ( ( i.color * ( tex2DNode8.b * _Intensity ) ) * smoothstepResult13 );
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
2674;420;1722;915;1393.249;578.8076;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;9;-998.3967,-231.632;Float;False;Property;_Float0;Float 0;3;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-1377.605,-78.5662;Float;True;Property;_VFX_Spots_Clouds_Dot;VFX_Spots_Clouds_Dot;1;0;Create;True;4bddc3a600889a943906204a238fa1d2;4bddc3a600889a943906204a238fa1d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;2;-642.3005,-534.899;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-991.1966,-102.2319;Float;False;Property;_Float1;Float 1;2;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-728,164.5;Float;False;Property;_Intensity;Intensity;0;0;Create;True;2;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-708.396,-130.9319;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-724.7385,-325.9452;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-559,56.5;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-563.5126,-224.8787;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-369,25.5;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-188,54.5;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_Flash;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;12;0;2;4
WireConnection;12;1;8;3
WireConnection;3;0;8;3
WireConnection;3;1;4;0
WireConnection;13;0;12;0
WireConnection;13;1;9;0
WireConnection;13;2;11;0
WireConnection;5;0;2;0
WireConnection;5;1;3;0
WireConnection;6;0;5;0
WireConnection;6;1;13;0
WireConnection;0;0;6;0
ASEEND*/
//CHKSM=B9948277B1CC3627C8F2BCCE5731D6E74747ABAB