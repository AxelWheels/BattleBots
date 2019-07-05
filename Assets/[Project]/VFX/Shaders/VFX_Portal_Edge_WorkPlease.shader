// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Portal_Edge_WorkPlease"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample10("Texture Sample 10", 2D) = "white" {}
		_TextureSample11("Texture Sample 11", 2D) = "white" {}
		_OverallIntensity("Overall Intensity", Range( 0 , 10)) = 1
		_TextureSample16("Texture Sample 16", 2D) = "white" {}
		_TextureSample14("Texture Sample 14", 2D) = "white" {}
		_TextureSample8("Texture Sample 8", 2D) = "white" {}
		_TextureSample6("Texture Sample 6", 2D) = "white" {}
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_TextureSample7("Texture Sample 7", 2D) = "white" {}
		_DiffCloud1_Intensity("DiffCloud1_Intensity", Range( 0 , 10)) = 1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_DiffCloud2_Intensity("DiffCloud2_Intensity", Range( 0 , 10)) = 1
		_TextureSample9("Texture Sample 9", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0.4627451,1,0)
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
				uniform sampler2D _TextureSample16;
				uniform sampler2D _TextureSample14;
				uniform float4 _TextureSample14_ST;
				uniform sampler2D _TextureSample8;
				uniform sampler2D _TextureSample11;
				uniform sampler2D _TextureSample10;
				uniform sampler2D _TextureSample9;
				uniform sampler2D _TextureSample0;
				uniform sampler2D _TextureSample6;
				uniform float _DiffCloud1_Intensity;
				uniform sampler2D _TextureSample4;
				uniform sampler2D _TextureSample7;
				uniform float _DiffCloud2_Intensity;
				uniform sampler2D _TextureSample3;
				uniform sampler2D _TextureSample1;
				uniform float _OverallIntensity;

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

					float2 uv63 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner68 = ( uv63 + 1.0 * _Time.y * float2( 0,-0.01 ));
					float2 uv_TextureSample14 = i.texcoord * _TextureSample14_ST.xy + _TextureSample14_ST.zw;
					float4 tex2DNode59 = tex2D( _TextureSample14, uv_TextureSample14 );
					float2 uv22 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner28 = ( uv22 + 1.0 * _Time.y * float2( -0.01,0.05 ));
					float2 uv13 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner32 = ( uv13 + 1.0 * _Time.y * float2( -0.02,-0.06 ));
					float lerpResult60 = lerp( tex2D( _TextureSample8, panner28 ).g , tex2D( _TextureSample11, panner32 ).g , 0.5);
					float2 uv24 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner34 = ( uv24 + 1.0 * _Time.y * float2( -0.02,-0.1 ));
					float lerpResult71 = lerp( lerpResult60 , ( tex2D( _TextureSample10, panner34 ).r * 5.0 ) , 0.5);
					float2 uv23 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner33 = ( uv23 + 1.0 * _Time.y * float2( -0.01,-0.05 ));
					float2 uv10 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner26 = ( uv10 + 1.0 * _Time.y * float2( -0.02,-0.06 ));
					float2 uv3 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner19 = ( uv3 + 1.0 * _Time.y * float2( 0,-0.03 ));
					float2 uv12 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner20 = ( uv12 + 1.0 * _Time.y * float2( 0,-0.03 ));
					float2 uv1 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner14 = ( uv1 + 1.0 * _Time.y * float2( -0.01,0.05 ));
					float2 uv2 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner21 = ( uv2 + 1.0 * _Time.y * float2( 0.01,-0.05 ));
					float2 uv5 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner16 = ( uv5 + 1.0 * _Time.y * float2( 0.01,-0.05 ));
					

					fixed4 col = ( _Color0 * ( ( ( ( tex2D( _TextureSample16, panner68 ).a * ( tex2DNode59.r * lerpResult71 ) ) + ( ( ( tex2DNode59.g * ( tex2D( _TextureSample9, panner33 ).r * 5.0 ) ) + ( tex2DNode59.g * ( ( tex2D( _TextureSample0, panner26 ).g * tex2D( _TextureSample6, panner19 ).b ) * _DiffCloud1_Intensity ) ) ) + ( ( tex2DNode59.r * ( ( tex2D( _TextureSample4, panner20 ).b * tex2D( _TextureSample7, panner14 ).g ) * _DiffCloud2_Intensity ) ) + ( ( ( tex2DNode59.b * tex2D( _TextureSample3, panner21 ).g ) * 0.5 ) + ( ( tex2DNode59.a * tex2D( _TextureSample1, panner16 ).g ) * 0.1 ) ) ) ) ) * tex2DNode59.r ) * _OverallIntensity ) );
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
2003;102;1666;931;1646.412;483.7319;1.629014;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-2490.057,1276.614;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;6;-2462.967,2177.185;Float;False;Constant;_Vector1;Vector 1;5;0;Create;True;0,-0.03;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;11;-2464.031,1686.821;Float;False;Constant;_Vector5;Vector 5;5;0;Create;True;0,-0.03;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;8;-2475.552,2486.447;Float;False;Constant;_Vector3;Vector 3;5;0;Create;True;-0.01,0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2479.197,2055.344;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2506.272,2860.763;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2491.782,2364.606;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;7;-2490.042,2982.605;Float;False;Constant;_Vector2;Vector 2;5;0;Create;True;0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;9;-2473.827,1398.455;Float;False;Constant;_Vector4;Vector 4;5;0;Create;True;-0.02,-0.06;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2480.261,1564.98;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-2479.231,3389.012;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;4;-2463.001,3510.854;Float;False;Constant;_Vector0;Vector 0;5;0;Create;True;0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-2498.768,92.28461;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2465.348,-418.7214;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;25;-2470.178,-46.77835;Float;False;Constant;_Vector9;Vector 9;5;0;Create;True;-0.02,-0.06;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-2486.408,-168.6196;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;17;-2449.117,-296.8801;Float;False;Constant;_Vector7;Vector 7;5;0;Create;True;-0.01,0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-2491.412,695.9587;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;15;-2482.538,214.1259;Float;False;Constant;_Vector6;Vector 6;5;0;Create;True;-0.02,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;16;-2210.571,3430.289;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;26;-2221.394,1317.89;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;21;-2237.611,2902.04;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;19;-2211.599,1606.256;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;14;-2223.121,2405.882;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;18;-2475.182,817.7999;Float;False;Constant;_Vector8;Vector 8;5;0;Create;True;-0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;20;-2210.533,2096.619;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;32;-2217.746,-127.3435;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;38;-2016.228,2376.476;Float;True;Property;_TextureSample7;Texture Sample 7;9;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;28;-2196.685,-377.4451;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;33;-2222.749,737.2349;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;34;-2230.104,133.5609;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;59;-3575.68,1293.833;Float;True;Property;_TextureSample14;Texture Sample 14;5;0;Create;True;0727e588e6d17a54eaddaa5f633a819e;0727e588e6d17a54eaddaa5f633a819e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;-2036.531,2863.766;Float;True;Property;_TextureSample3;Texture Sample 3;12;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;37;-1952.194,1565.895;Float;True;Property;_TextureSample6;Texture Sample 6;7;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-1958.442,2079.733;Float;True;Property;_TextureSample4;Texture Sample 4;8;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;29;-2011.543,3399.473;Float;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;-1947.181,1242.367;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;00d962d93477f0e48980153d7460d7b8;00d962d93477f0e48980153d7460d7b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-1660.912,-213.116;Float;False;Constant;_Float1;Float 1;5;0;Create;True;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-2019.77,-406.6959;Float;True;Property;_TextureSample8;Texture Sample 8;6;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;48;-1955.891,58.03788;Float;True;Property;_TextureSample10;Texture Sample 10;1;0;Create;True;00d962d93477f0e48980153d7460d7b8;00d962d93477f0e48980153d7460d7b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-1960.86,-140.7684;Float;True;Property;_TextureSample11;Texture Sample 11;2;0;Create;True;00d962d93477f0e48980153d7460d7b8;00d962d93477f0e48980153d7460d7b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1518.123,3371.702;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1328.906,2962.648;Float;False;Constant;_Float2;Float 2;15;0;Create;True;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1577.145,183.7329;Float;False;Constant;_Float5;Float 5;5;0;Create;True;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1432.118,3523.384;Float;False;Constant;_Float0;Float 0;17;0;Create;True;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1466.707,2823.55;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;-2041.637,694.2194;Float;True;Property;_TextureSample9;Texture Sample 9;14;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1484.292,1459.749;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1542.611,2289.787;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1627.24,798.686;Float;False;Constant;_Float6;Float 6;8;0;Create;True;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1358.473,1615.596;Float;False;Property;_DiffCloud1_Intensity;DiffCloud1_Intensity;10;0;Create;True;1;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1431.711,2437.653;Float;False;Property;_DiffCloud2_Intensity;DiffCloud2_Intensity;13;0;Create;True;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;66;-1790.833,-731.7902;Float;False;Constant;_Vector10;Vector 10;5;0;Create;True;0,-0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-1807.063,-853.6316;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1180.706,2762.448;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;60;-1449.443,-257.0578;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1357.436,-70.30556;Float;False;Constant;_Float7;Float 7;5;0;Create;True;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1261.248,1468.328;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1324.773,2256.782;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1421.976,93.10297;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1484.751,681.5417;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1266.363,3326.354;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;71;-1184.415,-143.0842;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1301.44,634.1833;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-1105.401,1382.541;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;68;-1538.4,-812.3554;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-868.7765,2633.414;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1124.097,2200.011;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;-1316.402,-813.9985;Float;True;Property;_TextureSample16;Texture Sample 16;4;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-888.9235,830.0557;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-748.4087,2236.021;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1018.253,-262.5502;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-652.1258,880.0847;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-797.0669,-369.6376;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-708.8584,254.7736;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-451.1401,267.1359;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-356.8403,432.7961;Float;False;Property;_OverallIntensity;Overall Intensity;3;0;Create;True;1;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;82;-521.4126,-228.8529;Float;False;Property;_Color0;Color 0;15;0;Create;True;0,0.4627451,1,0;0,0.4627451,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-287.9885,145.6337;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-259.44,-20.61819;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_Portal_Edge_WorkPlease;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;16;0;5;0
WireConnection;16;2;4;0
WireConnection;26;0;10;0
WireConnection;26;2;9;0
WireConnection;21;0;2;0
WireConnection;21;2;7;0
WireConnection;19;0;3;0
WireConnection;19;2;11;0
WireConnection;14;0;1;0
WireConnection;14;2;8;0
WireConnection;20;0;12;0
WireConnection;20;2;6;0
WireConnection;32;0;13;0
WireConnection;32;2;25;0
WireConnection;38;1;14;0
WireConnection;28;0;22;0
WireConnection;28;2;17;0
WireConnection;33;0;23;0
WireConnection;33;2;18;0
WireConnection;34;0;24;0
WireConnection;34;2;15;0
WireConnection;31;1;21;0
WireConnection;37;1;19;0
WireConnection;35;1;20;0
WireConnection;29;1;16;0
WireConnection;27;1;26;0
WireConnection;40;1;28;0
WireConnection;48;1;34;0
WireConnection;50;1;32;0
WireConnection;47;0;59;4
WireConnection;47;1;29;2
WireConnection;43;0;59;3
WireConnection;43;1;31;2
WireConnection;46;1;33;0
WireConnection;49;0;27;2
WireConnection;49;1;37;3
WireConnection;44;0;35;3
WireConnection;44;1;38;2
WireConnection;62;0;43;0
WireConnection;62;1;42;0
WireConnection;60;0;40;2
WireConnection;60;1;50;2
WireConnection;60;2;41;0
WireConnection;64;0;49;0
WireConnection;64;1;51;0
WireConnection;57;0;44;0
WireConnection;57;1;45;0
WireConnection;55;0;48;1
WireConnection;55;1;52;0
WireConnection;54;0;46;1
WireConnection;54;1;53;0
WireConnection;61;0;47;0
WireConnection;61;1;39;0
WireConnection;71;0;60;0
WireConnection;71;1;55;0
WireConnection;71;2;65;0
WireConnection;70;0;59;2
WireConnection;70;1;54;0
WireConnection;72;0;59;2
WireConnection;72;1;64;0
WireConnection;68;0;63;0
WireConnection;68;2;66;0
WireConnection;69;0;62;0
WireConnection;69;1;61;0
WireConnection;73;0;59;1
WireConnection;73;1;57;0
WireConnection;77;1;68;0
WireConnection;75;0;70;0
WireConnection;75;1;72;0
WireConnection;76;0;73;0
WireConnection;76;1;69;0
WireConnection;74;0;59;1
WireConnection;74;1;71;0
WireConnection;79;0;75;0
WireConnection;79;1;76;0
WireConnection;78;0;77;4
WireConnection;78;1;74;0
WireConnection;81;0;78;0
WireConnection;81;1;79;0
WireConnection;86;0;81;0
WireConnection;86;1;59;1
WireConnection;83;0;86;0
WireConnection;83;1;80;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;0;0;84;0
ASEEND*/
//CHKSM=C96D964E668E08D01BFDC544B7650CD5A0976E3B