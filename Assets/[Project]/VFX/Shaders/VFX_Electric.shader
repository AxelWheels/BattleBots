// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Electric"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Line("Line", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_Wiggle_Instensity("Wiggle_Instensity", Float) = 0
		_Noisetile1("Noise tile 1", Vector) = (0.1,0,0,0)
		_Noisespeed0("Noise speed0", Vector) = (0.1,0.1,0,0)
		_Brightness_intensity("Brightness_intensity", Float) = 10
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
				uniform sampler2D _Line;
				uniform sampler2D _Noise;
				uniform float2 _Noisespeed0;
				uniform float2 _Noisetile1;
				uniform float _Wiggle_Instensity;
				uniform float _Brightness_intensity;

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

					float2 uv3 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 uv11 = i.texcoord * _Noisetile1 + float2( 0,0 );
					float2 panner10 = ( uv11 + 1.0 * _Time.y * _Noisespeed0);
					float4 temp_cast_1 = (1.0).xxxx;
					float2 uv21 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					

					fixed4 col = ( i.color.a * ( i.color * ( tex2D( _Line, ( float4( uv3, 0.0 , 0.0 ) + ( ( ( ( tex2D( _Noise, panner10 ) * 2.0 ) - temp_cast_1 ) * _Wiggle_Instensity ) * ( 1.0 - abs( ( ( uv21.x * 2.0 ) - 1.0 ) ) ) ) ).rg ) * _Brightness_intensity ) ) );
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
2636;442;1722;915;150.8248;443.7773;1.3;True;True
Node;AmplifyShaderEditor.Vector2Node;13;-1228.345,18.25314;Float;False;Property;_Noisetile1;Noise tile 1;3;0;Create;True;0.1,0;0.1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;12;-1032.736,123.6364;Float;False;Property;_Noisespeed0;Noise speed0;4;0;Create;True;0.1,0.1;0.1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1057.502,0.1954777;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;34;-901.8118,425.0185;Float;False;1053.629;417.6116;0 - 1 - 0;8;21;23;22;25;24;26;28;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;10;-832.2537,106.1335;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-716.093,650.9577;Float;False;Constant;_Float0;Float 0;5;0;Create;True;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-851.8118,516.7605;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;35;-384.0932,78.75143;Float;False;438.8463;267.5869;-1 - 0 - 1;4;14;16;17;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-504.2493,674.2883;Float;False;Constant;_Float3;Float 3;5;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-334.0932,230.5856;Float;False;Constant;_Float1;Float 1;5;0;Create;True;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-561.9669,554.1674;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-664.9818,31.17519;Float;True;Property;_Noise;Noise;1;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-166.4496,231.3383;Float;False;Constant;_Float2;Float 2;5;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-357.8195,560.1786;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-281.1533,131.5933;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;26;-192.3032,574.4429;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-119.2469,128.7514;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-178.4943,475.0185;Float;False;Constant;_Float4;Float 4;5;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;42.53558,243.9191;Float;False;Property;_Wiggle_Instensity;Wiggle_Instensity;2;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-22.18283,504.3088;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;88.39429,138.83;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;367.194,328.2095;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-87.58284,-46.08405;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;8;269.1609,56.5307;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;756.1252,193.2756;Float;False;Property;_Brightness_intensity;Brightness_intensity;5;0;Create;True;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;488.9809,-13.65977;Float;True;Property;_Line;Line;0;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;891.7258,83.67563;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;36;763.0765,-394.3767;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;990.1628,-164.7814;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;33;579.3654,-190.7814;Float;False;Property;_Color0;Color 0;6;0;Create;True;0,0.3793104,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;1154.375,-162.9773;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;1;1310.026,-103.7022;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_Electric;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;11;0;13;0
WireConnection;10;0;11;0
WireConnection;10;2;12;0
WireConnection;22;0;21;1
WireConnection;22;1;23;0
WireConnection;4;1;10;0
WireConnection;24;0;22;0
WireConnection;24;1;25;0
WireConnection;14;0;4;0
WireConnection;14;1;15;0
WireConnection;26;0;24;0
WireConnection;16;0;14;0
WireConnection;16;1;17;0
WireConnection;27;0;28;0
WireConnection;27;1;26;0
WireConnection;6;0;16;0
WireConnection;6;1;7;0
WireConnection;29;0;6;0
WireConnection;29;1;27;0
WireConnection;8;0;3;0
WireConnection;8;1;29;0
WireConnection;2;1;8;0
WireConnection;30;0;2;0
WireConnection;30;1;31;0
WireConnection;32;0;36;0
WireConnection;32;1;30;0
WireConnection;37;0;36;4
WireConnection;37;1;32;0
WireConnection;1;0;37;0
ASEEND*/
//CHKSM=6942A44C0D2800E7EB6D6B62B1F56FCA9DF620A0