// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Portal_VoidSmoke"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Intensity("Intensity", Range( 0 , 1)) = 0.5
		_VoidSmoke_Mask("VoidSmoke_Mask", 2D) = "white" {}
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
				uniform sampler2D _VoidSmoke_Mask;
				uniform float4 _VoidSmoke_Mask_ST;
				uniform sampler2D _TextureSample4;
				uniform sampler2D _TextureSample1;
				uniform sampler2D _TextureSample2;
				uniform sampler2D _TextureSample0;
				uniform sampler2D _TextureSample3;
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

					float2 uv_VoidSmoke_Mask = i.texcoord * _VoidSmoke_Mask_ST.xy + _VoidSmoke_Mask_ST.zw;
					float2 uv22 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner23 = ( uv22 + 1.0 * _Time.y * float2( -0.01,-0.05 ));
					float2 temp_cast_0 = (1.3).xx;
					float2 uv2 = i.texcoord * temp_cast_0 + float2( 0,0 );
					float2 panner8 = ( uv2 + 1.0 * _Time.y * float2( 0.02,-0.1 ));
					float2 uv4 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner9 = ( uv4 + 1.0 * _Time.y * float2( 0.025,-0.04 ));
					float2 uv1 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner7 = ( uv1 + 1.0 * _Time.y * float2( -0.01,-0.04 ));
					float2 uv17 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner18 = ( uv17 + 1.0 * _Time.y * float2( -0.01,-0.05 ));
					

					fixed4 col = ( _Color0 * ( tex2D( _VoidSmoke_Mask, uv_VoidSmoke_Mask ) * ( ( tex2D( _TextureSample4, panner23 ).g * ( ( tex2D( _TextureSample1, panner8 ) * tex2D( _TextureSample2, panner9 ) ) * ( tex2D( _TextureSample0, panner7 ) * tex2D( _TextureSample3, panner18 ).g ) ) ) * _Intensity ) ) );
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
1961;102;1666;931;2846.616;140.9432;1.809735;True;True
Node;AmplifyShaderEditor.RangedFloatNode;20;-2742.722,396.0556;Float;False;Constant;_Float0;Float 0;4;0;Create;True;1.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;3;-2485.637,503.3613;Float;False;Constant;_Vector0;Vector 0;2;0;Create;True;0.02,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2557.185,1198.503;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;6;-2483.936,1070.058;Float;False;Constant;_Vector2;Vector 2;2;0;Create;True;-0.01,-0.04;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;5;-2488.836,772.1617;Float;False;Constant;_Vector1;Vector 1;2;0;Create;True;0.025,-0.04;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2515.175,649.7605;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2511.976,380.9604;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;16;-2530.845,1320.904;Float;False;Constant;_Vector3;Vector 3;2;0;Create;True;-0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2510.276,947.6567;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;18;-2253.504,1240.336;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;7;-2206.596,989.4902;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;8;-2208.298,422.7939;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;9;-2211.496,691.5939;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;10;-1971.269,1010.202;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;d5bef754157b8a546808c4d34889a25c;d5bef754157b8a546808c4d34889a25c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1991.953,148.0924;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-1976.168,712.3054;Float;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;d5bef754157b8a546808c4d34889a25c;d5bef754157b8a546808c4d34889a25c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-2029.769,1228.602;Float;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-1972.97,443.5054;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;d5bef754157b8a546808c4d34889a25c;d5bef754157b8a546808c4d34889a25c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;21;-1965.613,270.4934;Float;False;Constant;_Vector4;Vector 4;2;0;Create;True;-0.01,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1527.969,1131.102;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;23;-1688.272,189.9254;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1544.026,636.7714;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;24;-1464.537,178.1914;Float;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;1e5c93fc4ce80e4498a9298bae9c2981;1e5c93fc4ce80e4498a9298bae9c2981;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1219.665,794.6896;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-918.8296,591.5536;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-819.0302,782.3981;Float;False;Property;_Intensity;Intensity;5;0;Create;True;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-603.6736,649.3322;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;28;-759.5004,405.9616;Float;True;Property;_VoidSmoke_Mask;VoidSmoke_Mask;6;0;Create;True;f266331228cadff439b5389308ef1a30;f266331228cadff439b5389308ef1a30;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;32;-582.3319,196.6916;Float;False;Property;_Color0;Color 0;7;0;Create;True;0,0.4627451,1,0;0,0.4627451,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-426.8359,612.564;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-272.8876,331.5133;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_Portal_VoidSmoke;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;2;0;20;0
WireConnection;18;0;17;0
WireConnection;18;2;16;0
WireConnection;7;0;1;0
WireConnection;7;2;6;0
WireConnection;8;0;2;0
WireConnection;8;2;3;0
WireConnection;9;0;4;0
WireConnection;9;2;5;0
WireConnection;10;1;7;0
WireConnection;12;1;9;0
WireConnection;19;1;18;0
WireConnection;11;1;8;0
WireConnection;13;0;10;0
WireConnection;13;1;19;2
WireConnection;23;0;22;0
WireConnection;23;2;21;0
WireConnection;14;0;11;0
WireConnection;14;1;12;0
WireConnection;24;1;23;0
WireConnection;34;0;14;0
WireConnection;34;1;13;0
WireConnection;25;0;24;2
WireConnection;25;1;34;0
WireConnection;26;0;25;0
WireConnection;26;1;27;0
WireConnection;29;0;28;0
WireConnection;29;1;26;0
WireConnection;33;0;32;0
WireConnection;33;1;29;0
WireConnection;0;0;33;0
ASEEND*/
//CHKSM=213B03F6F450F793E75D315B4E8EFB29FAA2C81E