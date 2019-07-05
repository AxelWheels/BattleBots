// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Portal_InnerCurve"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_VFX_Portal_Clouds1_Clouds2_DiffClouds_DotsNoise("VFX_Portal_Clouds1_Clouds2_DiffClouds_DotsNoise", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Inner_Thing("Inner_Thing", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_VFX_Portal_InnerMad_InnerCurve_Dim_Bright("VFX_Portal_InnerMad_InnerCurve_Dim_Bright", 2D) = "white" {}
		_Intensity("Intensity", Range( 0 , 10)) = 4.784362
		_Color0("Color 0", Color) = (0,0.4627451,1,0)
		_PanningUpIntensity("PanningUp Intensity", Range( 0 , 50)) = 5
		_PassiveIntensity("Passive Intensity", Range( 0 , 2)) = 1
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
				uniform sampler2D _TextureSample3;
				uniform float4 _TextureSample3_ST;
				uniform sampler2D _TextureSample4;
				uniform sampler2D _VFX_Portal_InnerMad_InnerCurve_Dim_Bright;
				uniform sampler2D _TextureSample1;
				uniform sampler2D _TextureSample0;
				uniform sampler2D _Inner_Thing;
				uniform sampler2D _VFX_Portal_Clouds1_Clouds2_DiffClouds_DotsNoise;
				uniform float _PanningUpIntensity;
				uniform float _PassiveIntensity;
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

					float2 uv_TextureSample3 = i.texcoord * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
					float4 tex2DNode27 = tex2D( _TextureSample3, uv_TextureSample3 );
					float2 uv42 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner43 = ( uv42 + 1.0 * _Time.y * float2( -0.01,-0.05 ));
					float2 uv28 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner30 = ( uv28 + 1.0 * _Time.y * float2( 0,-0.3 ));
					float2 temp_cast_0 = (1.3).xx;
					float2 uv17 = i.texcoord * temp_cast_0 + float2( 0,0 );
					float2 panner16 = ( uv17 + 1.0 * _Time.y * float2( 0.02,-0.1 ));
					float4 tex2DNode18 = tex2D( _TextureSample1, panner16 );
					float2 uv13 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner12 = ( uv13 + 1.0 * _Time.y * float2( 0.025,-0.1 ));
					float2 uv8 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner10 = ( uv8 + 1.0 * _Time.y * float2( -0.01,-0.15 ));
					float2 uv2 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner3 = ( uv2 + 1.0 * _Time.y * float2( -0.01,-0.05 ));
					float4 temp_output_32_0 = ( tex2DNode18 * ( ( tex2DNode18 * tex2D( _TextureSample0, panner12 ) ) + ( tex2D( _Inner_Thing, panner10 ) * tex2D( _VFX_Portal_Clouds1_Clouds2_DiffClouds_DotsNoise, panner3 ).g ) ) );
					

					fixed4 col = ( _Color0 * ( ( ( ( tex2DNode27.b * tex2D( _TextureSample4, panner43 ).g ) * 0.15 ) + ( ( ( ( tex2DNode27.g * tex2D( _VFX_Portal_InnerMad_InnerCurve_Dim_Bright, panner30 ).r ) * temp_output_32_0 ) * _PanningUpIntensity ) + ( tex2DNode27.g * ( temp_output_32_0 * _PassiveIntensity ) ) ) ) * _Intensity ) );
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
2003;102;1666;931;2500.325;1142.752;1.890957;True;True
Node;AmplifyShaderEditor.RangedFloatNode;19;-2833.296,151.204;Float;False;Constant;_Float0;Float 0;4;0;Create;True;1.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2600.85,702.8049;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-2605.749,404.9091;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;15;-2576.211,258.5099;Float;False;Constant;_Vector3;Vector 3;2;0;Create;True;0.02,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2602.55,136.1088;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2647.759,953.6511;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;11;-2579.41,527.3099;Float;False;Constant;_Vector2;Vector 2;2;0;Create;True;0.025,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;1;-2621.419,1076.053;Float;False;Constant;_Vector0;Vector 0;2;0;Create;True;-0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;9;-2574.51,825.206;Float;False;Constant;_Vector1;Vector 1;2;0;Create;True;-0.01,-0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;10;-2297.17,744.6384;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;12;-2302.07,446.7424;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;16;-2298.872,177.9423;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;3;-2344.078,995.4844;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-2120.343,983.7502;Float;True;Property;_VFX_Portal_Clouds1_Clouds2_DiffClouds_DotsNoise;VFX_Portal_Clouds1_Clouds2_DiffClouds_DotsNoise;2;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-2190.019,-341.3674;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;29;-2163.679,-218.9665;Float;False;Constant;_Vector5;Vector 5;2;0;Create;True;0,-0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;14;-2066.742,467.4539;Float;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;d5bef754157b8a546808c4d34889a25c;d5bef754157b8a546808c4d34889a25c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-2061.843,765.3498;Float;True;Property;_Inner_Thing;Inner_Thing;5;0;Create;True;d5bef754157b8a546808c4d34889a25c;d5bef754157b8a546808c4d34889a25c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-2063.544,198.6538;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;d5bef754157b8a546808c4d34889a25c;d5bef754157b8a546808c4d34889a25c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1634.601,391.9199;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;30;-1886.34,-299.5341;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1618.544,886.2498;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;27;-1626.736,-484.2451;Float;True;Property;_TextureSample3;Texture Sample 3;6;0;Create;True;c95d4549e55dd52409e31f3f36d19117;c95d4549e55dd52409e31f3f36d19117;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-2148.962,-805.5964;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-1633.009,-267.8017;Float;True;Property;_VFX_Portal_InnerMad_InnerCurve_Dim_Bright;VFX_Portal_InnerMad_InnerCurve_Dim_Bright;7;0;Create;True;c95d4549e55dd52409e31f3f36d19117;c95d4549e55dd52409e31f3f36d19117;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;44;-2122.623,-683.1956;Float;False;Constant;_Vector6;Vector 6;2;0;Create;True;-0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1370.582,234.7007;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;43;-1845.283,-763.7631;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1129.035,104.6613;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-1092.009,240.4614;Float;False;Property;_PassiveIntensity;Passive Intensity;11;0;Create;True;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1043.278,-308.5816;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-845.7747,-159.0587;Float;False;Property;_PanningUpIntensity;PanningUp Intensity;10;0;Create;True;5;10;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-839.9324,129.4312;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-887.5859,-291.7196;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;45;-1621.548,-775.4975;Float;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-1089.893,-538.4913;Float;False;Constant;_Float4;Float 4;8;0;Create;True;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1106.389,-683.482;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-694.6835,-242.9982;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-625.4335,10.91894;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-867.9116,-678.8769;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-455.4507,-156.96;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-429.7206,-507.17;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-130.8142,-425.1169;Float;False;Property;_Intensity;Intensity;8;0;Create;True;4.784362;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;-54.30713,-902.0614;Float;False;Property;_Color0;Color 0;9;0;Create;True;0,0.4627451,1,0;0,0.4627451,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-25.00745,-578.1298;Float;False;2;2;0;COLOR;0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;22;-1656.409,-48.53917;Float;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;24;-2157.484,43.76278;Float;False;Constant;_Vector4;Vector 4;2;0;Create;True;-0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;23;-1880.144,-36.8048;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;193.1179,-737.6539;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-2183.823,-78.63808;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMasterNode;0;397.5497,-739.0303;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_Portal_InnerCurve;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;17;0;19;0
WireConnection;10;0;8;0
WireConnection;10;2;9;0
WireConnection;12;0;13;0
WireConnection;12;2;11;0
WireConnection;16;0;17;0
WireConnection;16;2;15;0
WireConnection;3;0;2;0
WireConnection;3;2;1;0
WireConnection;5;1;3;0
WireConnection;14;1;12;0
WireConnection;7;1;10;0
WireConnection;18;1;16;0
WireConnection;20;0;18;0
WireConnection;20;1;14;0
WireConnection;30;0;28;0
WireConnection;30;2;29;0
WireConnection;6;0;7;0
WireConnection;6;1;5;2
WireConnection;26;1;30;0
WireConnection;21;0;20;0
WireConnection;21;1;6;0
WireConnection;43;0;42;0
WireConnection;43;2;44;0
WireConnection;32;0;18;0
WireConnection;32;1;21;0
WireConnection;31;0;27;2
WireConnection;31;1;26;1
WireConnection;85;0;32;0
WireConnection;85;1;87;0
WireConnection;84;0;31;0
WireConnection;84;1;32;0
WireConnection;45;1;43;0
WireConnection;46;0;27;3
WireConnection;46;1;45;2
WireConnection;89;0;84;0
WireConnection;89;1;90;0
WireConnection;88;0;27;2
WireConnection;88;1;85;0
WireConnection;47;0;46;0
WireConnection;47;1;48;0
WireConnection;86;0;89;0
WireConnection;86;1;88;0
WireConnection;82;0;47;0
WireConnection;82;1;86;0
WireConnection;50;0;82;0
WireConnection;50;1;51;0
WireConnection;22;1;23;0
WireConnection;23;0;25;0
WireConnection;23;2;24;0
WireConnection;52;0;53;0
WireConnection;52;1;50;0
WireConnection;0;0;52;0
ASEEND*/
//CHKSM=9431D78CB327B9800F7082A37E527299E59CD70E