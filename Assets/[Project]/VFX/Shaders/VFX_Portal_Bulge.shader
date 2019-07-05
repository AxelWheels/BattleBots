// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Portal_Bulge"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Bulge_Mask("Bulge_Mask", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Clouds_2("Clouds_2", 2D) = "white" {}
		_Intensity2("Intensity 2", Float) = 0.1
		_Intensity1("Intensity 1", Float) = 0.2
		_IntensityMain("Intensity Main", Range( 0 , 5)) = 2
		_Color0("Color 0", Color) = (0,0.4627451,1,1)
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
				uniform float4 _Color0;
				uniform sampler2D _Bulge_Mask;
				uniform float4 _Bulge_Mask_ST;
				uniform sampler2D _Clouds_2;
				uniform float _Intensity1;
				uniform sampler2D _TextureSample1;
				uniform float4 _TextureSample1_ST;
				uniform sampler2D _TextureSample0;
				uniform float _Intensity2;
				uniform float _IntensityMain;

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

					float2 uv_Bulge_Mask = i.texcoord * _Bulge_Mask_ST.xy + _Bulge_Mask_ST.zw;
					float2 uv4 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner3 = ( uv4 + 1.0 * _Time.y * float2( -0.01,-0.05 ));
					float2 uv_TextureSample1 = i.texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
					float2 uv10 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner9 = ( uv10 + 1.0 * _Time.y * float2( -0.01,-0.05 ));
					

					fixed4 col = ( _Color0 * ( ( ( ( tex2D( _Bulge_Mask, uv_Bulge_Mask ) * tex2D( _Clouds_2, panner3 ) ) * _Intensity1 ) + ( ( tex2D( _TextureSample1, uv_TextureSample1 ) * tex2D( _TextureSample0, panner9 ) ) * _Intensity2 ) ) * _IntensityMain ) );
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
1961;102;1666;931;1181.23;131.9235;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1989.109,28.6107;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1996.685,463.5625;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;8;-1970.345,585.9636;Float;False;Constant;_Vector1;Vector 1;2;0;Create;True;-0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;5;-1962.769,151.0118;Float;False;Constant;_Vector0;Vector 0;2;0;Create;True;-0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;3;-1685.428,70.44398;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;9;-1693.004,505.3958;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;7;-1438.47,299.958;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;e3811111bdff2e44690c7e1860686cba;e3811111bdff2e44690c7e1860686cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1437.282,53.34107;Float;True;Property;_Clouds_2;Clouds_2;3;0;Create;True;ffc4da6e18bb0be44813c9eb9372293e;ffc4da6e18bb0be44813c9eb9372293e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1430.894,-134.9938;Float;True;Property;_Bulge_Mask;Bulge_Mask;1;0;Create;True;e3811111bdff2e44690c7e1860686cba;e3811111bdff2e44690c7e1860686cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-1444.858,488.2928;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;ffc4da6e18bb0be44813c9eb9372293e;ffc4da6e18bb0be44813c9eb9372293e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-994.4093,470.1841;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1020.749,11.56757;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-929.3351,138.6168;Float;False;Property;_Intensity1;Intensity 1;5;0;Create;True;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-926.2365,592.5851;Float;False;Property;_Intensity2;Intensity 2;4;0;Create;True;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-729.4652,25.51199;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-718.6196,474.8322;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-475.3667,443.8446;Float;False;Property;_IntensityMain;Intensity Main;6;0;Create;True;2;2;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-523.3975,264.1165;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;21;-453.6743,0.7220142;Float;False;Property;_Color0;Color 0;7;0;Create;True;0,0.4627451,1,1;0,0.4627451,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-297.188,279.6103;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-140.6997,183.5488;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_Portal_Bulge;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;3;0;4;0
WireConnection;3;2;5;0
WireConnection;9;0;10;0
WireConnection;9;2;8;0
WireConnection;2;1;3;0
WireConnection;6;1;9;0
WireConnection;11;0;7;0
WireConnection;11;1;6;0
WireConnection;12;0;1;0
WireConnection;12;1;2;0
WireConnection;13;0;12;0
WireConnection;13;1;16;0
WireConnection;14;0;11;0
WireConnection;14;1;15;0
WireConnection;17;0;13;0
WireConnection;17;1;14;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;20;0;21;0
WireConnection;20;1;18;0
WireConnection;0;0;20;0
ASEEND*/
//CHKSM=D58547966A10B3B11C9BA0D3A92FBC618598AF08