// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GlassMaster_MM"
{
	Properties
	{
		_ARM("ARM", 2D) = "white" {}
		_RGHContrast("RGH Contrast", Float) = 1
		_RGHIntensity("RGH Intensity", Float) = 1
		_AOContrast("AO Contrast", Float) = 1
		_AOIntensity("AO Intensity", Float) = 1
		_Metalic("Metalic", Range( 0 , 1)) = 0
		_ALB("ALB", 2D) = "white" {}
		_ALBContrast("ALB Contrast", Float) = 1
		_ALBBrightness("ALB Brightness", Float) = 1
		_ALBHue("ALB Hue", Range( 0 , 1)) = 0
		_ALBDesaturate("ALB Desaturate", Float) = 1
		_BlurAmount("Blur Amount", Range( 0 , 1)) = 0
		_NRM("NRM", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 2)) = 0.292
		_NormalScale("Normal Scale", Range( 0 , 2)) = 0
		_EMIS("EMIS", 2D) = "white" {}
		_EmisIntensity("Emis Intensity", Float) = 0
		_EmisColour("Emis Colour", Range( 0 , 1)) = 0
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_RefractionAmount("Refraction Amount", Float) = 0
		_AlbedoRGBOpacityA("Albedo(RGB) Opacity(A)", Color) = (0,0,0,0)
		_ReflectionStrength("Reflection Strength", Range( 0 , 1)) = 1
		_Opacity("Opacity", Float) = 1
		[Toggle] _ALBHueSwitch("ALB Hue Switch", Float) = 0.0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _ALBHUESWITCH_ON
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
		};

		uniform half _NormalIntensity;
		uniform half _NormalScale;
		uniform sampler2D _NRM;
		uniform float4 _NRM_ST;
		uniform half4 _AlbedoRGBOpacityA;
		uniform float _ALBContrast;
		uniform sampler2D _ALB;
		uniform sampler2D NoBlurALB;
		uniform half _BlurAmount;
		uniform float _ALBDesaturate;
		uniform float _ALBBrightness;
		uniform float _ALBHue;
		uniform half _ReflectionStrength;
		uniform sampler2D _EMIS;
		uniform float4 _EMIS_ST;
		uniform float _EmisIntensity;
		uniform float _EmisColour;
		uniform half _Metalic;
		uniform float _RGHContrast;
		uniform sampler2D _ARM;
		uniform float4 _ARM_ST;
		uniform float _RGHIntensity;
		uniform float _AOContrast;
		uniform float _AOIntensity;
		uniform float _Opacity;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;
		uniform float _RefractionAmount;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, clamp( p - K.xxx, 0.0, 1.0 ), c.y );
		}


		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( ( ( ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) ) * ( 1.0 / ( screenPos.z + 1.0 ) ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) ) );
			float2 cameraRefraction = float2( refractionOffset.x, -( refractionOffset.y * _ProjectionParams.x ) );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout fixed4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			float temp_output_116_0 = _RefractionAmount;
			color.rgb = color.rgb + Refraction( i, o, temp_output_116_0, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_NRM = i.uv_texcoord * _NRM_ST.xy + _NRM_ST.zw;
			float3 tex2DNode119 = UnpackScaleNormal( tex2D( _NRM, uv_NRM ) ,_NormalScale );
			float4 appendResult176 = (float4(( _NormalIntensity * tex2DNode119.r ) , ( _NormalIntensity * tex2DNode119.g ) , tex2DNode119.b , 0.0));
			o.Normal = appendResult176.xyz;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 temp_output_160_0 = (ase_grabScreenPosNorm).xy;
			float2 temp_output_161_0 = ( temp_output_160_0 + (( tex2DNode119 * _NormalIntensity )).xy );
			float4 tex2DNode117 = tex2D( _ALB, temp_output_161_0 );
			float4 lerpResult166 = lerp( tex2DNode117 , tex2D( NoBlurALB, temp_output_161_0 ) , _BlurAmount);
			float3 desaturateVar122 = lerp( CalculateContrast(_ALBContrast,lerpResult166).rgb,dot(CalculateContrast(_ALBContrast,lerpResult166).rgb,float3(0.299,0.587,0.114)).xxx,_ALBDesaturate);
			float4 temp_cast_4 = (1.0).xxxx;
			float3 hsvTorgb3_g11 = HSVToRGB( float3(_ALBHue,1.0,1.0) );
			float4 appendResult152 = (float4(( 0.0 * hsvTorgb3_g11.x ) , ( 0.0 * hsvTorgb3_g11.y ) , ( 0.0 * hsvTorgb3_g11.z ) , 0.0));
			#ifdef _ALBHUESWITCH_ON
				float4 staticSwitch185 = appendResult152;
			#else
				float4 staticSwitch185 = temp_cast_4;
			#endif
			float4 lerpResult169 = lerp( _AlbedoRGBOpacityA , ( float4( ( desaturateVar122 * _ALBBrightness ) , 0.0 ) * staticSwitch185 ) , _ReflectionStrength);
			o.Albedo = lerpResult169.xyz;
			float2 uv_EMIS = i.uv_texcoord * _EMIS_ST.xy + _EMIS_ST.zw;
			float3 hsvTorgb3_g12 = HSVToRGB( float3(_EmisColour,1.0,1.0) );
			o.Emission = ( ( tex2D( _EMIS, uv_EMIS ) * _EmisIntensity ) * float4( hsvTorgb3_g12 , 0.0 ) ).rgb;
			o.Metallic = _Metalic;
			float2 uv_ARM = i.uv_texcoord * _ARM_ST.xy + _ARM_ST.zw;
			float4 tex2DNode118 = tex2D( _ARM, uv_ARM );
			float4 temp_cast_8 = (( ( 1.0 - tex2DNode118.g ) * _RGHIntensity )).xxxx;
			o.Smoothness = CalculateContrast(_RGHContrast,temp_cast_8).r;
			float4 temp_cast_10 = (( tex2DNode118.r * _AOIntensity )).xxxx;
			o.Occlusion = CalculateContrast(_AOContrast,temp_cast_10).r;
			o.Alpha = ( tex2DNode117.a * _Opacity );
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float4 tSpace0 : TEXCOORD4;
				float4 tSpace1 : TEXCOORD5;
				float4 tSpace2 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
-1819;83;1585;900;2707.464;780.4247;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;154;-4894.727,-455.8829;Half;False;Property;_NormalScale;Normal Scale;15;0;Create;True;0;0.86;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;119;-4522.016,-569.0675;Float;True;Property;_NRM;NRM;13;0;Create;True;None;302951faffe230848aa0d3df7bb70faa;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;156;-4547.501,-203.7663;Half;False;Property;_NormalIntensity;Normal Intensity;14;0;Create;True;0.292;0.31;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;158;-4587.474,-824.9881;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-4167.344,-510.7426;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;160;-4260.357,-691.0847;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;177;-4008.438,-528.1312;Float;False;True;True;False;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;161;-3734.968,-627.0612;Float;True;2;2;0;FLOAT2;0.0,0;False;1;FLOAT2;0.0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;163;-3498.861,-525.7411;Float;True;Global;NoBlurALB;No Blur ALB;11;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;117;-3487.041,-756.9847;Float;True;Property;_ALB;ALB;6;0;Create;True;None;163c7d802dfde76419095b9e3643950d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;162;-3292.299,-970.4406;Half;False;Property;_BlurAmount;Blur Amount;12;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-2607.605,-721.979;Float;False;Property;_ALBHue;ALB Hue;9;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-2563.453,-834.6655;Float;False;Property;_ALBContrast;ALB Contrast;7;0;Create;True;1;0.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;166;-2954.327,-813.4778;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;148;-2280.915,-714.202;Float;False;Simple HUE;-1;;11;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0.0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.RangedFloatNode;125;-2333.775,-831.8625;Float;False;Property;_ALBDesaturate;ALB Desaturate;10;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;121;-2440.094,-914.6651;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-2045.313,-560.8667;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-2043.583,-744.8281;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-2044.853,-652.7879;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-2111.208,-830.6784;Float;False;Property;_ALBBrightness;ALB Brightness;8;0;Create;True;1;1.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;122;-2208.153,-914.893;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;118;-1829.018,-242.205;Float;True;Property;_ARM;ARM;0;0;Create;True;None;163c7d802dfde76419095b9e3643950d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;184;-1973.825,-448.0184;Float;False;Constant;_Float2;Float 2;25;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;152;-1869.725,-712.406;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-1275.855,-1249.244;Float;False;Property;_EmisColour;Emis Colour;18;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-1373.419,40.36674;Float;False;Property;_AOIntensity;AO Intensity;4;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-1981.651,-914.039;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;146;-1410.418,-332.0158;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;185;-1812.627,-510.4182;Float;False;Property;_ALBHueSwitch;ALB Hue Switch;25;0;Create;True;0;False;False;True;;Toggle;2;1;FLOAT4;0.0;False;0;FLOAT4;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-1395.503,-219.7551;Float;False;Property;_RGHIntensity;RGH Intensity;2;0;Create;True;1;1.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;120;-1334.266,-1647.698;Float;True;Property;_EMIS;EMIS;16;0;Create;True;None;256939d1f3a3ac745891458eaaf06278;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;138;-1021.836,-1377.813;Float;False;Property;_EmisIntensity;Emis Intensity;17;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;139;-937.796,-1275.637;Float;False;Simple HUE;-1;;12;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0.0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.RangedFloatNode;145;-1211.694,-225.7328;Float;False;Property;_RGHContrast;RGH Contrast;1;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-4112.832,-360.311;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-820.2572,-1396.235;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-1521.157,-546.6401;Float;False;Property;_Opacity;Opacity;24;0;Create;True;1;-3.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;167;-1826.318,-1119.226;Half;False;Property;_AlbedoRGBOpacityA;Albedo(RGB) Opacity(A);22;0;Create;True;0,0,0,0;0.5735295,0.4723184,0.4723184,0.209;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;165;-1830.247,-1228.187;Half;False;Property;_ReflectionStrength;Reflection Strength;23;0;Create;True;1;0.78;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-1186.728,-69.45921;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-4128.98,-255.108;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-1711.077,-707.0411;Float;False;2;2;0;FLOAT3;0,0,0,0;False;1;FLOAT4;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-1208.811,-329.5807;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-1189.61,34.38921;Float;False;Property;_AOContrast;AO Contrast;3;0;Create;True;1;-0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;183;-4246.281,-849.2806;Half;False;Property;_Refraction;Refraction;19;0;Create;True;0.292;0.005;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-1251.477,-606.8312;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-555.4636,-239.4365;Float;False;Constant;_Float0;Float 0;0;0;Create;True;1.52;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-622.2262,-1305.498;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;114;-304.5335,-274.0397;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-3917.344,-723.2549;Float;False;2;2;0;FLOAT2;0,0,0;False;1;FLOAT;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-587.6566,-729.8998;Half;False;Property;_Metalic;Metalic;5;0;Create;True;0;0.42;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;169;-1373.046,-1105.988;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;176;-3917.452,-313.5317;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-584.0588,-318.3677;Float;False;Property;_RefractionAmount;Refraction Amount;21;0;Create;True;0;1.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;142;-1000.813,-352.7798;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;133;-978.7285,-92.65779;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;113;-564.2318,-157.179;Float;False;Tangent;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;5.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-36.6845,-825.5793;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;GlassMaster_MM;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;False;0;Translucent;0.5;True;True;0;False;Opaque;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;20;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;119;5;154;0
WireConnection;157;0;119;0
WireConnection;157;1;156;0
WireConnection;160;0;158;0
WireConnection;177;0;157;0
WireConnection;161;0;160;0
WireConnection;161;1;177;0
WireConnection;163;1;161;0
WireConnection;117;1;161;0
WireConnection;166;0;117;0
WireConnection;166;1;163;0
WireConnection;166;2;162;0
WireConnection;148;1;147;0
WireConnection;121;1;166;0
WireConnection;121;0;124;0
WireConnection;150;1;148;8
WireConnection;151;1;148;7
WireConnection;149;1;148;5
WireConnection;122;0;121;0
WireConnection;122;1;125;0
WireConnection;152;0;151;0
WireConnection;152;1;149;0
WireConnection;152;2;150;0
WireConnection;123;0;122;0
WireConnection;123;1;126;0
WireConnection;146;0;118;2
WireConnection;185;1;184;0
WireConnection;185;0;152;0
WireConnection;139;1;137;0
WireConnection;178;0;156;0
WireConnection;178;1;119;1
WireConnection;140;0;120;0
WireConnection;140;1;138;0
WireConnection;134;0;118;1
WireConnection;134;1;135;0
WireConnection;175;0;156;0
WireConnection;175;1;119;2
WireConnection;153;0;123;0
WireConnection;153;1;185;0
WireConnection;143;0;146;0
WireConnection;143;1;144;0
WireConnection;108;0;117;4
WireConnection;108;1;111;0
WireConnection;182;0;140;0
WireConnection;182;1;139;6
WireConnection;114;0;116;0
WireConnection;114;1;115;0
WireConnection;114;2;113;0
WireConnection;179;0;160;0
WireConnection;179;1;183;0
WireConnection;169;0;167;0
WireConnection;169;1;153;0
WireConnection;169;2;165;0
WireConnection;176;0;178;0
WireConnection;176;1;175;0
WireConnection;176;2;119;3
WireConnection;142;1;143;0
WireConnection;142;0;145;0
WireConnection;133;1;134;0
WireConnection;133;0;136;0
WireConnection;0;0;169;0
WireConnection;0;1;176;0
WireConnection;0;2;182;0
WireConnection;0;3;170;0
WireConnection;0;4;142;0
WireConnection;0;5;133;0
WireConnection;0;8;116;0
WireConnection;0;9;108;0
ASEEND*/
//CHKSM=8CD008BAE3061B38C132C72D25FC0E0FA2E12112