// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_MenuSelect"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_MenuSelect_Sides_Bright_Centre_Flicker("MenuSelect_Sides_Bright_Centre_Flicker", 2D) = "white" {}
		_Instensity_Centre("Instensity_Centre", Range( 0 , 10)) = 1
		_Instensity_Centre_Bright("Instensity_Centre_Bright", Range( 0 , 10)) = 1
		_Instensity_TopBottom("Instensity_TopBottom", Range( 0 , 10)) = 1
		_Color0("Color 0", Color) = (0,0.7103448,1,0)
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
				uniform sampler2D _MenuSelect_Sides_Bright_Centre_Flicker;
				uniform float4 _MenuSelect_Sides_Bright_Centre_Flicker_ST;
				uniform float _Instensity_TopBottom;
				uniform float _Instensity_Centre_Bright;
				uniform float _Instensity_Centre;
				uniform sampler2D _TextureSample0;

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

					float2 uv_MenuSelect_Sides_Bright_Centre_Flicker = i.texcoord * _MenuSelect_Sides_Bright_Centre_Flicker_ST.xy + _MenuSelect_Sides_Bright_Centre_Flicker_ST.zw;
					float4 tex2DNode1 = tex2D( _MenuSelect_Sides_Bright_Centre_Flicker, uv_MenuSelect_Sides_Bright_Centre_Flicker );
					float2 uv10 = i.texcoord * float2( 1,1 ) + float2( 0,0 );
					float2 panner9 = ( uv10 + 1.0 * _Time.y * float2( 0,0.05 ));
					

					fixed4 col = ( _Color0 * ( ( ( tex2DNode1.r * _Instensity_TopBottom ) + ( tex2DNode1.g * _Instensity_Centre_Bright ) + ( tex2DNode1.b * _Instensity_Centre ) ) * tex2D( _TextureSample0, panner9 ).a ) );
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
2636;442;1722;915;1941.228;221.0312;1.175;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1624.213,264.6465;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1238.288,-83.1739;Float;True;Property;_MenuSelect_Sides_Bright_Centre_Flicker;MenuSelect_Sides_Bright_Centre_Flicker;1;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-861.5125,24.66859;Float;False;Property;_Instensity_TopBottom;Instensity_TopBottom;4;0;Create;True;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-843.3558,265.5167;Float;False;Property;_Instensity_Centre;Instensity_Centre;2;0;Create;True;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-848.6961,142.6895;Float;False;Property;_Instensity_Centre_Bright;Instensity_Centre_Bright;3;0;Create;True;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;11;-1563.334,377.8613;Float;False;Constant;_Vector0;Vector 0;5;0;Create;True;0,0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-605.1782,-36.21092;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-592.3619,81.81001;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;9;-1400.985,324.4575;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-587.0217,204.6371;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-1237.568,297.7563;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-414.8173,64.5884;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-272.5385,141.2;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-313.5816,-114.628;Float;False;Property;_Color0;Color 0;5;0;Create;True;0,0.7103448,1,0;0,0.7103448,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-487.7533,351.1937;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-111.1084,102.8939;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMasterNode;0;112.1811,71.13921;Float;False;True;2;Float;ASEMaterialInspector;0;5;VFX_MenuSelect;0b6a9f8b4f707c74ca64c0be8e590de0;Particles Alpha Blended;4;One;One;0;One;Zero;Off;True;True;True;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;2;1;3;0
WireConnection;4;0;1;2
WireConnection;4;1;5;0
WireConnection;9;0;10;0
WireConnection;9;2;11;0
WireConnection;6;0;1;3
WireConnection;6;1;7;0
WireConnection;8;1;9;0
WireConnection;12;0;2;0
WireConnection;12;1;4;0
WireConnection;12;2;6;0
WireConnection;13;0;12;0
WireConnection;13;1;8;4
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;0;0;15;0
ASEEND*/
//CHKSM=53C5967D24694A5DF00A7332A0E5C46B832B8301