// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Helix_Flame"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_VFX_Helix_Flame("VFX_Helix_Flame", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Clouds_2("Clouds_2", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0.462069,1,0)
		_Intensity("Intensity", Range( 1 , 50)) = 1
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
				uniform sampler2D _VFX_Helix_Flame;
				uniform sampler2D _Clouds_2;
				uniform sampler2D _TextureSample0;
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

					float2 uv18 = i.texcoord * float2( -1,-1 ) + float2( 0,0 );
					float2 uv5 = i.texcoord * float2( 1,1 ) + float2( -1,0 );
					float2 panner6 = ( uv5 + 1.0 * _Time.y * float2( 1.5,0.03 ));
					float2 uv4 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner7 = ( uv4 + 1.0 * _Time.y * float2( 2,0 ));
					

					fixed4 col = ( _Color0 * ( ( tex2D( _VFX_Helix_Flame, uv18 ) * ( tex2D( _Clouds_2, panner6 ) * tex2D( _TextureSample0, panner7 ) ) ) * _Intensity ) );
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
2685;438;1666;902;1620.477;627.637;1.354506;True;True
Node;AmplifyShaderEditor.Vector2Node;16;-2019.021,-65.86023;Float;False;Constant;_Vector2;Vector 2;4;0;Create;True;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;9;-1734.826,76.5688;Float;False;Constant;_Vector1;Vector 1;3;0;Create;True;1.5,0.03;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1756.696,191.18;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1809.505,-38.79662;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;8;-1702.814,347.6095;Float;False;Constant;_Vector0;Vector 0;3;0;Create;True;2,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;6;-1521.531,-21.01902;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;7;-1436.933,191.8293;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;17;-1689.045,-220.0156;Float;False;Constant;_Vector3;Vector 3;4;0;Create;True;-1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;3;-1165.082,207.7873;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;ffc4da6e18bb0be44813c9eb9372293e;ffc4da6e18bb0be44813c9eb9372293e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1161.639,2.803712;Float;True;Property;_Clouds_2;Clouds_2;2;0;Create;True;ffc4da6e18bb0be44813c9eb9372293e;ffc4da6e18bb0be44813c9eb9372293e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1468.848,-237.4694;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-768.9197,180.5692;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-1163.845,-216.7106;Float;True;Property;_VFX_Helix_Flame;VFX_Helix_Flame;0;0;Create;True;e79c183939056d54ca0fa97557d3f268;e79c183939056d54ca0fa97557d3f268;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-592.1196,73.96924;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-528.623,217.271;Float;False;Property;_Intensity;Intensity;4;0;Create;True;1;0;1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-494.99,-160.0875;Float;False;Property;_Color0;Color 0;3;0;Create;True;0,0.462069,1,0;0,0.462069,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-375.623,79.27097;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-206.016,-50.54578;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_Helix_Flame;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;5;1;16;0
WireConnection;6;0;5;0
WireConnection;6;2;9;0
WireConnection;7;0;4;0
WireConnection;7;2;8;0
WireConnection;3;1;7;0
WireConnection;2;1;6;0
WireConnection;18;0;17;0
WireConnection;10;0;2;0
WireConnection;10;1;3;0
WireConnection;1;1;18;0
WireConnection;11;0;1;0
WireConnection;11;1;10;0
WireConnection;14;0;11;0
WireConnection;14;1;15;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;0;0;13;0
ASEEND*/
//CHKSM=43F33CB88DEB8DFF965327957C88940EA0AB04C8