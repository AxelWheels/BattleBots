// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hex_Edge_Intensity"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Glow_Intensity("Glow_Intensity", Range( 0 , 10)) = 1
		_Hex_Base_Intensity("Hex_Base_Intensity", Range( 0 , 10)) = 1
		_Hex_Instensity("Hex_Instensity", Range( 0 , 10)) = 1
		_Base_Instensity("Base_Instensity", Range( 0 , 2)) = 0.2
		_Colour("Colour", Color) = (0,0.7931032,1,0)
		_Clouds("Clouds", 2D) = "white" {}
		_Shield_Masks_Base_Hex_Glow("Shield_Masks_Base_Hex_Glow", 2D) = "white" {}
		_Clouds_2("Clouds_2", 2D) = "white" {}
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
				#include "UnityShaderVariables.cginc"


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
				uniform float4 _Colour;
				uniform sampler2D _Shield_Masks_Base_Hex_Glow;
				uniform float4 _Shield_Masks_Base_Hex_Glow_ST;
				uniform float _Base_Instensity;
				uniform float _Glow_Intensity;
				uniform sampler2D _Clouds_2;
				uniform float _Hex_Instensity;
				uniform sampler2D _Clouds;
				uniform float _Hex_Base_Intensity;

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

					float2 uv_Shield_Masks_Base_Hex_Glow = i.texcoord * _Shield_Masks_Base_Hex_Glow_ST.xy + _Shield_Masks_Base_Hex_Glow_ST.zw;
					float4 tex2DNode34 = tex2D( _Shield_Masks_Base_Hex_Glow, uv_Shield_Masks_Base_Hex_Glow );
					float temp_output_7_0 = ( tex2DNode34.b * _Glow_Intensity );
					float2 _Vector2 = float2(0.7,0.7);
					float2 uv14 = i.texcoord * _Vector2 + float2( 0,0 );
					float2 panner15 = ( uv14 + 1.0 * _Time.y * float2( 0.05,-0.01 ));
					float4 tex2DNode29 = tex2D( _Clouds_2, panner15 );
					float2 uv18 = i.texcoord * _Vector2 + float2( 0,0 );
					float2 panner17 = ( uv18 + 1.0 * _Time.y * float2( 0.05,0.01 ));
					float4 temp_output_22_0 = ( ( tex2DNode34.g * _Hex_Instensity ) * ( tex2DNode29 * tex2D( _Clouds, panner17 ) ) );
					

					fixed4 col = ( _Colour * ( ( ( tex2DNode34.r * _Base_Instensity ) + ( temp_output_7_0 + ( temp_output_7_0 * ( tex2DNode29 * 0.5 ) ) ) ) + ( ( temp_output_22_0 * _Hex_Base_Intensity ) + ( tex2DNode34.b * temp_output_22_0 ) ) ) );
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
2636;442;1722;915;2536.576;487.9418;1.84048;True;True
Node;AmplifyShaderEditor.Vector2Node;24;-2111.077,502.8948;Float;False;Constant;_Vector2;Vector 2;7;0;Create;True;0.7,0.7;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1854.519,692.4652;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;19;-1845.151,850.1077;Float;False;Constant;_Vector1;Vector 1;6;0;Create;True;0.05,0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;16;-1836.907,534.905;Float;False;Constant;_Vector0;Vector 0;6;0;Create;True;0.05,-0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-1846.275,377.2625;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;17;-1606.346,778.3098;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;15;-1598.102,463.1071;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1333.966,141.9553;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1598.721,374.7976;Float;False;Property;_Hex_Instensity;Hex_Instensity;2;0;Create;True;1;0.2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-1354.539,739.4156;Float;True;Property;_Clouds;Clouds;5;0;Create;True;b0ace40ef9431dc4a8329626c2a781f6;b0ace40ef9431dc4a8329626c2a781f6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;-2131.95,-241.2267;Float;True;Property;_Shield_Masks_Base_Hex_Glow;Shield_Masks_Base_Hex_Glow;6;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-1756.295,-18.31382;Float;False;Property;_Glow_Intensity;Glow_Intensity;0;0;Create;True;1;0.2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-1373.973,478.5951;Float;True;Property;_Clouds_2;Clouds_2;7;0;Create;True;ffc4da6e18bb0be44813c9eb9372293e;ffc4da6e18bb0be44813c9eb9372293e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1025.281,680.0616;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1239.849,361.5576;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1484.525,-79.85049;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1147.739,124.6313;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-939.9871,464.7925;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-994.1841,77.15776;Float;False;2;2;0;FLOAT;0.0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-937.7405,-127.8102;Float;False;Property;_Base_Instensity;Base_Instensity;3;0;Create;True;0.2;0.2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1146.501,296.2567;Float;False;Property;_Hex_Base_Intensity;Hex_Base_Intensity;1;0;Create;True;1;0.2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-793.626,28.29286;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-660.7298,311.3965;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-856.6873,326.7782;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-724.7405,-218.81;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-568.2401,154.4863;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-487.5029,-80.9333;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-420.189,71.69601;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;11;-414.7531,-308.9631;Float;False;Property;_Colour;Colour;4;0;Create;True;0,0.7931032,1,0;0,0.7931032,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-195.0443,-39.71216;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;5;Hex_Edge_Intensity;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;18;0;24;0
WireConnection;14;0;24;0
WireConnection;17;0;18;0
WireConnection;17;2;19;0
WireConnection;15;0;14;0
WireConnection;15;2;16;0
WireConnection;26;1;17;0
WireConnection;29;1;15;0
WireConnection;21;0;29;0
WireConnection;21;1;26;0
WireConnection;5;0;34;2
WireConnection;5;1;4;0
WireConnection;7;0;34;3
WireConnection;7;1;6;0
WireConnection;31;0;29;0
WireConnection;31;1;32;0
WireConnection;22;0;5;0
WireConnection;22;1;21;0
WireConnection;30;0;7;0
WireConnection;30;1;31;0
WireConnection;33;0;7;0
WireConnection;33;1;30;0
WireConnection;42;0;34;3
WireConnection;42;1;22;0
WireConnection;35;0;22;0
WireConnection;35;1;36;0
WireConnection;2;0;34;1
WireConnection;2;1;3;0
WireConnection;37;0;35;0
WireConnection;37;1;42;0
WireConnection;9;0;2;0
WireConnection;9;1;33;0
WireConnection;8;0;9;0
WireConnection;8;1;37;0
WireConnection;12;0;11;0
WireConnection;12;1;8;0
WireConnection;0;0;12;0
ASEEND*/
//CHKSM=82EEBBE9E3FDD1427D4D25D37AD27F1591146D39