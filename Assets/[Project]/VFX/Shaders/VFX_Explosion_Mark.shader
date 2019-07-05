// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Explosion_Mark_Energy"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_VFX_Spots_Clouds_Dot("VFX_Spots_Clouds_Dot", 2D) = "white" {}
		_Vector0("Vector 0", Vector) = (-0.02,0,0,0)
		_Panner("Panner", Vector) = (0.02,0.02,0,0)
		_Instensity("Instensity", Range( 1 , 10)) = 0
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_VFX_ExplosionMark_Lines_Clouds("VFX_ExplosionMark_Lines_Clouds", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
			
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

		
		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform sampler2D _VFX_Spots_Clouds_Dot;
			uniform float4 _VFX_Spots_Clouds_Dot_ST;
			uniform sampler2D _VFX_ExplosionMark_Lines_Clouds;
			uniform float4 _VFX_ExplosionMark_Lines_Clouds_ST;
			uniform sampler2D _TextureSample3;
			uniform float2 _Panner;
			uniform sampler2D _TextureSample0;
			uniform float2 _Vector0;
			uniform float _Instensity;
			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				float2 uv_VFX_Spots_Clouds_Dot = IN.texcoord.xy * _VFX_Spots_Clouds_Dot_ST.xy + _VFX_Spots_Clouds_Dot_ST.zw;
				float2 uv_VFX_ExplosionMark_Lines_Clouds = IN.texcoord.xy * _VFX_ExplosionMark_Lines_Clouds_ST.xy + _VFX_ExplosionMark_Lines_Clouds_ST.zw;
				float2 uv8 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7 = ( uv8 + 1.0 * _Time.y * _Panner);
				float2 uv23 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner24 = ( uv23 + 1.0 * _Time.y * _Vector0);
				
				fixed4 c = ( IN.color * ( ( ( tex2D( _VFX_Spots_Clouds_Dot, uv_VFX_Spots_Clouds_Dot ).b * tex2D( _VFX_ExplosionMark_Lines_Clouds, uv_VFX_ExplosionMark_Lines_Clouds ).g ) * ( tex2D( _TextureSample3, panner7 ).b * tex2D( _TextureSample0, panner24 ).b ) ) * _Instensity ) );
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
2653;452;1722;915;1959.76;488.1329;1.6;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1663.28,190.4599;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;9;-1652.28,302.4599;Float;False;Property;_Panner;Panner;2;0;Create;True;0.02,0.02;0.02,0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1677.562,427.3812;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;22;-1666.562,539.3811;Float;False;Property;_Vector0;Vector 0;1;0;Create;True;-0.02,0;-0.02,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;7;-1400.28,235.4599;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;24;-1414.562,472.3811;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;31;-1172.56,221.3814;Float;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;6cb6e53cbc08bd7408833c9a7a44ef8e;6cb6e53cbc08bd7408833c9a7a44ef8e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1046.931,-172.2218;Float;True;Property;_VFX_Spots_Clouds_Dot;VFX_Spots_Clouds_Dot;0;0;Create;True;4bddc3a600889a943906204a238fa1d2;4bddc3a600889a943906204a238fa1d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;32;-1168.661,409.8814;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;6cb6e53cbc08bd7408833c9a7a44ef8e;6cb6e53cbc08bd7408833c9a7a44ef8e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;29;-1172.562,26.38118;Float;True;Property;_VFX_ExplosionMark_Lines_Clouds;VFX_ExplosionMark_Lines_Clouds;6;0;Create;True;6cb6e53cbc08bd7408833c9a7a44ef8e;6cb6e53cbc08bd7408833c9a7a44ef8e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-769.5608,340.9811;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-713.931,-27.22183;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-617.4592,425.4814;Float;False;Property;_Instensity;Instensity;3;0;Create;True;0;4.14;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-577.7816,258.0597;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;12;-516.0598,65.38116;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-378.2599,311.0813;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-219.66,248.6814;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;20;-275.5607,140.781;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMasterNode;21;93.60001,-2.6;Float;False;True;2;Float;ASEMaterialInspector;0;4;VFX_Explosion_Mark_Energy;0f8ba0101102bb14ebf021ddadce9b49;Sprites Default;3;One;OneMinusSrcAlpha;0;One;Zero;Off;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;7;0;8;0
WireConnection;7;2;9;0
WireConnection;24;0;23;0
WireConnection;24;2;22;0
WireConnection;31;1;7;0
WireConnection;32;1;24;0
WireConnection;28;0;31;3
WireConnection;28;1;32;3
WireConnection;5;0;4;3
WireConnection;5;1;29;2
WireConnection;11;0;5;0
WireConnection;11;1;28;0
WireConnection;14;0;11;0
WireConnection;14;1;15;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;21;0;13;0
ASEEND*/
//CHKSM=63F90D2C61B66AFFDDF2F34436B1C39280B1589D