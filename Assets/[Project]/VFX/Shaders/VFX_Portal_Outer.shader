// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Portal_Outer"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_TextureSample5("Texture Sample 5", 2D) = "white" {}
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_OuterMadMask("OuterMadMask", 2D) = "white" {}
		_Intensity("Intensity", Range( 0 , 5)) = 1
		_Color0("Color 0", Color) = (0,0.4627451,1,0)
		_GlowIntensity("Glow Intensity", Range( 0 , 2)) = 0.8
		_Dots_Intensity("Dots_Intensity", Range( 0 , 50)) = 5
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
				uniform sampler2D _TextureSample4;
				uniform sampler2D _OuterMadMask;
				uniform float4 _OuterMadMask_ST;
				uniform sampler2D _TextureSample0;
				uniform sampler2D _TextureSample2;
				uniform sampler2D _TextureSample1;
				uniform float _Dots_Intensity;
				uniform float _GlowIntensity;
				uniform sampler2D _TextureSample3;
				uniform sampler2D _TextureSample5;
				uniform float _Intensity;

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

					float2 uv17 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner21 = ( uv17 + 1.0 * _Time.y * float2( 0,-0.01 ));
					float4 tex2DNode24 = tex2D( _TextureSample4, panner21 );
					float4 appendResult53 = (float4(tex2DNode24.a , tex2DNode24.a , tex2DNode24.a , tex2DNode24.a));
					float2 uv_OuterMadMask = i.texcoord * _OuterMadMask_ST.xy + _OuterMadMask_ST.zw;
					float4 tex2DNode26 = tex2D( _OuterMadMask, uv_OuterMadMask );
					float2 uv51 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner7 = ( uv51 + 1.0 * _Time.y * float2( -0.01,0.05 ));
					float2 uv1 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner8 = ( uv1 + 1.0 * _Time.y * float2( -0.02,-0.06 ));
					float lerpResult16 = lerp( tex2D( _TextureSample0, panner7 ).g , tex2D( _TextureSample2, panner8 ).g , 0.5);
					float2 uv5 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner9 = ( uv5 + 1.0 * _Time.y * float2( -0.02,-0.1 ));
					float lerpResult22 = lerp( lerpResult16 , ( tex2D( _TextureSample1, panner9 ).r * 5.0 ) , 0.5);
					float2 uv28 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner29 = ( uv28 + 1.0 * _Time.y * float2( -0.01,-0.05 ));
					float2 uv31 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner32 = ( uv31 + 1.0 * _Time.y * float2( -0.01,-0.05 ));
					

					fixed4 col = ( _Color0 * ( ( ( ( appendResult53 * ( tex2DNode26 * lerpResult22 ) ) * _Dots_Intensity ) + ( _GlowIntensity * ( ( ( tex2DNode26 * tex2D( _TextureSample3, panner29 ).g ) * 0.2 ) + ( ( tex2DNode26 * tex2D( _TextureSample5, panner32 ).g ) * 0.1 ) ) ) ) * _Intensity ) );
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
2567;382;1722;915;1612.304;957.3802;1.262401;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-2304.766,-446.9516;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;2;-2221.428,-58.43755;Float;False;Constant;_Vector0;Vector 0;5;0;Create;True;-0.02,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-2237.658,-180.2789;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;6;-2209.069,-319.3417;Float;False;Constant;_Vector2;Vector 2;5;0;Create;True;-0.02,-0.06;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2225.299,-441.183;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;3;-2188.008,-569.4435;Float;False;Constant;_Vector1;Vector 1;5;0;Create;True;-0.01,0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;8;-1956.636,-399.9068;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;9;-1968.995,-139.0027;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;7;-1935.575,-650.0086;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;34;-2316.413,815.2341;Float;False;Constant;_Vector5;Vector 5;2;0;Create;True;-0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;27;-2288.795,456.2014;Float;False;Constant;_Vector4;Vector 4;2;0;Create;True;-0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-2315.136,333.8004;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-2342.754,692.8331;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-1758.66,-679.2593;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-1316.036,-88.83068;Float;False;Constant;_Float1;Float 1;5;0;Create;True;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-1699.75,-413.3317;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;00d962d93477f0e48980153d7460d7b8;00d962d93477f0e48980153d7460d7b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-1399.803,-485.6794;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;19;-1763.979,-843.8373;Float;False;Constant;_Vector3;Vector 3;5;0;Create;True;0,-0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;32;-2039.073,734.6661;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;29;-2011.455,375.6334;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1780.209,-965.6788;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-1694.781,-214.5257;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;00d962d93477f0e48980153d7460d7b8;00d962d93477f0e48980153d7460d7b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;16;-1188.334,-529.6213;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1096.327,-342.869;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1160.867,-179.4606;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-1511.546,-924.4023;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;30;-1787.72,363.8994;Float;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-2872.844,12.30426;Float;True;Property;_OuterMadMask;OuterMadMask;6;0;Create;True;6fbbdbe847a572e4fbcdf16d82c4fede;6fbbdbe847a572e4fbcdf16d82c4fede;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;-1815.338,722.9321;Float;True;Property;_TextureSample5;Texture Sample 5;3;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1253.908,763.3285;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;24;-1297.823,-800.559;Float;True;Property;_TextureSample4;Texture Sample 4;4;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;22;-923.3063,-415.6475;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1159.972,896.9807;Float;False;Constant;_Float3;Float 3;7;0;Create;True;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1167.962,497.4625;Float;False;Constant;_Float4;Float 4;7;0;Create;True;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1272.348,364.6124;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-757.1443,-535.1136;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-745.2568,-751.8223;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-966.2056,769.1349;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-978.1911,375.6095;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-571.5233,-654.0558;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-972.2671,-172.167;Float;False;Property;_Dots_Intensity;Dots_Intensity;10;0;Create;True;5;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-722.3022,528.1439;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-857.0149,151.1159;Float;False;Property;_GlowIntensity;Glow Intensity;9;0;Create;True;0.8;0.8;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-689.4891,-312.2935;Float;False;2;2;0;FLOAT4;0.0;False;1;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-637.3896,248.3271;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-533.9923,43.82561;Float;False;Property;_Intensity;Intensity;7;0;Create;True;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-565.6704,-88.60681;Float;False;2;2;0;FLOAT4;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-315.8608,-103.4759;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;46;-361.1037,-429.2717;Float;False;Property;_Color0;Color 0;8;0;Create;True;0,0.4627451,1,0;0,0.4627451,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-97.73547,-262.9999;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;49;131.6049,-293.0404;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_Portal_Outer;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;8;0;1;0
WireConnection;8;2;6;0
WireConnection;9;0;5;0
WireConnection;9;2;2;0
WireConnection;7;0;51;0
WireConnection;7;2;3;0
WireConnection;10;1;7;0
WireConnection;13;1;8;0
WireConnection;32;0;31;0
WireConnection;32;2;34;0
WireConnection;29;0;28;0
WireConnection;29;2;27;0
WireConnection;12;1;9;0
WireConnection;16;0;10;2
WireConnection;16;1;13;2
WireConnection;16;2;11;0
WireConnection;15;0;12;1
WireConnection;15;1;14;0
WireConnection;21;0;17;0
WireConnection;21;2;19;0
WireConnection;30;1;29;0
WireConnection;33;1;32;0
WireConnection;36;0;26;0
WireConnection;36;1;33;2
WireConnection;24;1;21;0
WireConnection;22;0;16;0
WireConnection;22;1;15;0
WireConnection;22;2;18;0
WireConnection;35;0;26;0
WireConnection;35;1;30;2
WireConnection;23;0;26;0
WireConnection;23;1;22;0
WireConnection;53;0;24;4
WireConnection;53;1;24;4
WireConnection;53;2;24;4
WireConnection;53;3;24;4
WireConnection;38;0;36;0
WireConnection;38;1;39;0
WireConnection;37;0;35;0
WireConnection;37;1;40;0
WireConnection;25;0;53;0
WireConnection;25;1;23;0
WireConnection;41;0;37;0
WireConnection;41;1;38;0
WireConnection;56;0;25;0
WireConnection;56;1;57;0
WireConnection;54;0;55;0
WireConnection;54;1;41;0
WireConnection;42;0;56;0
WireConnection;42;1;54;0
WireConnection;44;0;42;0
WireConnection;44;1;43;0
WireConnection;45;0;46;0
WireConnection;45;1;44;0
WireConnection;49;0;45;0
ASEEND*/
//CHKSM=FDEC57AD09A7C728099BFB51336DF725317150CE