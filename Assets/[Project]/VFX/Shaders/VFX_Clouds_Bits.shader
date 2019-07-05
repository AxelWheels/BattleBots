// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Clouds_Smoke"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_VFX_Spots_Clouds_Dot("VFX_Spots_Clouds_Dot", 2D) = "white" {}
		_Intensity("Intensity", Range( 0 , 5)) = 1
		_BitsIntensity("Bits Intensity", Range( 0 , 5)) = 1
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
				uniform sampler2D _TextureSample2;
				uniform sampler2D _VFX_Spots_Clouds_Dot;
				uniform float4 _VFX_Spots_Clouds_Dot_ST;
				uniform float _BitsIntensity;
				uniform sampler2D _TextureSample1;
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

					float2 uv16 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner15 = ( uv16 + 1.0 * _Time.y * float2( 0.01,0.02 ));
					float2 uv_VFX_Spots_Clouds_Dot = i.texcoord * _VFX_Spots_Clouds_Dot_ST.xy + _VFX_Spots_Clouds_Dot_ST.zw;
					float4 tex2DNode1 = tex2D( _VFX_Spots_Clouds_Dot, uv_VFX_Spots_Clouds_Dot );
					float2 uv4 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner5 = ( uv4 + 1.0 * _Time.y * float2( 0.02,0 ));
					float4 tex2DNode3 = tex2D( _TextureSample1, panner5 );
					float2 uv9 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner8 = ( uv9 + 1.0 * _Time.y * float2( 0.01,-0.01 ));
					float4 tex2DNode2 = tex2D( _TextureSample0, panner8 );
					float lerpResult26 = lerp( tex2DNode3.g , tex2DNode2.g , 0.5);
					float lerpResult19 = lerp( ( ( tex2D( _TextureSample2, panner15 ).r * tex2DNode1.b ) * _BitsIntensity ) , ( tex2DNode1.b * lerpResult26 ) , 0.4);
					

					fixed4 col = ( ( i.color * ( lerpResult19 * _Intensity ) ) * i.color.a );
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
-2;355;1722;915;3118.404;998.6683;2.598132;True;True
Node;AmplifyShaderEditor.Vector2Node;14;-1616.008,-440.4619;Float;False;Constant;_Vector2;Vector 2;3;0;Create;True;0.01,0.02;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1638.809,-553.2173;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;6;-1606.71,7.922191;Float;False;Constant;_Vector0;Vector 0;3;0;Create;True;0.02,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1629.511,-104.8331;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;7;-1601.088,255.0925;Float;False;Constant;_Vector1;Vector 1;3;0;Create;True;0.01,-0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1623.889,142.3372;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;15;-1408.23,-451.8642;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;5;-1398.932,-3.48009;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;8;-1393.31,243.6902;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;17;-1159.167,-479.6758;Float;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;4bddc3a600889a943906204a238fa1d2;4bddc3a600889a943906204a238fa1d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1154.196,-273.6199;Float;True;Property;_VFX_Spots_Clouds_Dot;VFX_Spots_Clouds_Dot;3;0;Create;True;4bddc3a600889a943906204a238fa1d2;4bddc3a600889a943906204a238fa1d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1152.351,-30.50635;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;4bddc3a600889a943906204a238fa1d2;4bddc3a600889a943906204a238fa1d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1144.247,215.8788;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;4bddc3a600889a943906204a238fa1d2;4bddc3a600889a943906204a238fa1d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-828.3086,378.2599;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-762.5491,-257.6989;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-808.4748,-131.8634;Float;False;Property;_BitsIntensity;Bits Intensity;5;0;Create;True;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-654.3086,228.2599;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-605.5144,94.89153;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-497.6539,-25.78691;Float;False;Constant;_Float1;Float 1;4;0;Create;True;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-539.3762,-186.4634;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-311.1267,-65.39203;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-303.8806,61.24392;Float;False;Property;_Intensity;Intensity;4;0;Create;True;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-140.0812,-51.85603;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;21;-110.8894,-318.3587;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;168.4683,-122.0231;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-757.547,137.0517;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;391.4687,-120.6232;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;0;578.6099,-127.1508;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_Clouds_Smoke;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;15;0;16;0
WireConnection;15;2;14;0
WireConnection;5;0;4;0
WireConnection;5;2;6;0
WireConnection;8;0;9;0
WireConnection;8;2;7;0
WireConnection;17;1;15;0
WireConnection;3;1;5;0
WireConnection;2;1;8;0
WireConnection;18;0;17;1
WireConnection;18;1;1;3
WireConnection;26;0;3;2
WireConnection;26;1;2;2
WireConnection;26;2;27;0
WireConnection;11;0;1;3
WireConnection;11;1;26;0
WireConnection;32;0;18;0
WireConnection;32;1;33;0
WireConnection;19;0;32;0
WireConnection;19;1;11;0
WireConnection;19;2;20;0
WireConnection;22;0;19;0
WireConnection;22;1;23;0
WireConnection;30;0;21;0
WireConnection;30;1;22;0
WireConnection;10;0;3;2
WireConnection;10;1;2;2
WireConnection;31;0;30;0
WireConnection;31;1;21;4
WireConnection;0;0;31;0
ASEEND*/
//CHKSM=A583577F343CE92E35F2CAB571438FD2F9C87E33