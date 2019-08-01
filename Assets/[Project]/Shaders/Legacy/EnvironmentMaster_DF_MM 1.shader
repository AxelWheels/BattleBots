// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EnvironmentMaster_MM"
{
	Properties
	{
		_ARM("ARM", 2D) = "white" {}
		_RGHAmount("RGH Amount", Float) = 1
		_AOAmount("AO Amount", Float) = 1
		_AOContrast("AO Contrast", Float) = 1
		_ALB("ALB", 2D) = "white" {}
		_ALBContrast("ALB Contrast", Float) = 1
		_ALBBrightness("ALB Brightness", Float) = 1
		_ALBSaturation("ALB Saturation", Float) = 1
		_NRM("NRM", 2D) = "white" {}
		_NRMIntensity("NRM Intensity", Float) = 1
		_DetailNRM("Detail NRM", 2D) = "white" {}
		_DetailNRMIntensity("Detail NRM Intensity", Float) = 1
		_EMIS("EMIS", 2D) = "black" {}
		_EMISColour("EMIS Colour", Float) = 0
		_EMISValue("EMIS Value", Float) = 1
		[Toggle] _DirtMaskSwitch("Dirt Mask Switch", Float) = 0.0
		_DirtMask("Dirt Mask", 2D) = "white" {}
		_MaskContrast("Mask Contrast", Float) = 0
		[Toggle] _InvertDirt("Invert Dirt", Float) = 0.0
		_DirtColour("Dirt Colour", Color) = (0.1985294,0.1725152,0.1488971,0)
		_DirtRoughness("Dirt Roughness", Float) = 1
		_DirtAmount("Dirt Amount", Range( 0 , 1)) = 0
		_DirtContrast("Dirt Contrast", Range( 0 , 1)) = 0
		[Toggle] _ColourMaskSwitch("Colour Mask Switch", Float) = 0.0
		_ColourMask("Colour Mask", 2D) = "black" {}
		_Hue("Hue", Range( 0 , 1)) = 0.5
		_ColourBrightness("Colour Brightness", Float) = 1
		_ColourSaturation("Colour Saturation", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _COLOURMASKSWITCH_ON
		#pragma shader_feature _DIRTMASKSWITCH_ON
		#pragma shader_feature _INVERTDIRT_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NRM;
		uniform float4 _NRM_ST;
		uniform float _NRMIntensity;
		uniform sampler2D _DetailNRM;
		uniform float4 _DetailNRM_ST;
		uniform float _DetailNRMIntensity;
		uniform float _ALBContrast;
		uniform sampler2D _ALB;
		uniform float4 _ALB_ST;
		uniform float _ALBSaturation;
		uniform float _ALBBrightness;
		uniform float _Hue;
		uniform float _ColourSaturation;
		uniform float _ColourBrightness;
		uniform sampler2D _ColourMask;
		uniform float4 _ColourMask_ST;
		uniform float4 _DirtColour;
		uniform float _MaskContrast;
		uniform sampler2D _DirtMask;
		uniform float4 _DirtMask_ST;
		uniform float _DirtContrast;
		uniform sampler2D _ARM;
		uniform float4 _ARM_ST;
		uniform float _DirtAmount;
		uniform sampler2D _EMIS;
		uniform float4 _EMIS_ST;
		uniform float _EMISValue;
		uniform float _EMISColour;
		uniform float _RGHAmount;
		uniform float _DirtRoughness;
		uniform float _AOContrast;
		uniform float _AOAmount;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 temp_cast_0 = (0.0).xxxx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 lerpResult50 = lerp( temp_cast_0 , ( ( asin( _Time.y ) + ( asin( _Time.y ) + asin( _Time.y ) ) ) * ( ( ( v.color.r * 0.0 ) + float4(0,0,0,1) ) * float4( ase_worldPos , 0.0 ) ) ) , v.color.r);
			v.vertex.xyz += lerpResult50.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NRM = i.uv_texcoord * _NRM_ST.xy + _NRM_ST.zw;
			float3 tex2DNode2 = UnpackNormal( tex2D( _NRM, uv_NRM ) );
			float4 appendResult17 = (float4(( tex2DNode2.r * _NRMIntensity ) , ( tex2DNode2.g * _NRMIntensity ) , tex2DNode2.b , 0.0));
			float2 uv_DetailNRM = i.uv_texcoord * _DetailNRM_ST.xy + _DetailNRM_ST.zw;
			float4 tex2DNode107 = tex2D( _DetailNRM, uv_DetailNRM );
			float4 appendResult108 = (float4(( tex2DNode107.r * _DetailNRMIntensity ) , ( tex2DNode107.g * _DetailNRMIntensity ) , tex2DNode107.b , 0.0));
			o.Normal = BlendNormals( appendResult17.xyz , appendResult108.xyz );
			float2 uv_ALB = i.uv_texcoord * _ALB_ST.xy + _ALB_ST.zw;
			float4 tex2DNode1 = tex2D( _ALB, uv_ALB );
			float3 desaturateVar11 = lerp( tex2DNode1.rgb,dot(tex2DNode1.rgb,float3(0.299,0.587,0.114)).xxx,( 1.0 - _ALBSaturation ));
			float3 hsvTorgb3_g7 = HSVToRGB( float3(_Hue,1.0,1.0) );
			float temp_output_84_7 = hsvTorgb3_g7.x;
			float temp_output_84_5 = hsvTorgb3_g7.y;
			float temp_output_84_8 = hsvTorgb3_g7.z;
			float4 appendResult90 = (float4(( tex2DNode1.r * temp_output_84_7 ) , ( tex2DNode1.g * temp_output_84_5 ) , ( tex2DNode1.b * temp_output_84_8 ) , 0.0));
			float3 desaturateVar91 = lerp( appendResult90.xyz,dot(appendResult90.xyz,float3(0.299,0.587,0.114)).xxx,_ColourSaturation);
			float2 uv_ColourMask = i.uv_texcoord * _ColourMask_ST.xy + _ColourMask_ST.zw;
			float4 lerpResult29 = lerp( tex2DNode1 , float4( ( desaturateVar91 * _ColourBrightness ) , 0.0 ) , tex2D( _ColourMask, uv_ColourMask ).r);
			#ifdef _COLOURMASKSWITCH_ON
				float4 staticSwitch82 = lerpResult29;
			#else
				float4 staticSwitch82 = CalculateContrast(_ALBContrast,float4( ( desaturateVar11 * _ALBBrightness ) , 0.0 ));
			#endif
			float2 uv_DirtMask = i.uv_texcoord * _DirtMask_ST.xy + _DirtMask_ST.zw;
			#ifdef _DIRTMASKSWITCH_ON
				float4 staticSwitch129 = CalculateContrast(_MaskContrast,tex2D( _DirtMask, uv_DirtMask ));
			#else
				float4 staticSwitch129 = float4(0,0,0,0);
			#endif
			float4 temp_cast_6 = 0;
			float2 uv_ARM = i.uv_texcoord * _ARM_ST.xy + _ARM_ST.zw;
			float4 tex2DNode3 = tex2D( _ARM, uv_ARM );
			float4 temp_cast_7 = (( tex2DNode3.r * ( 1.0 - _DirtAmount ) )).xxxx;
			float4 temp_output_116_0 = CalculateContrast(( 1.0 - _DirtContrast ),temp_cast_7);
			#ifdef _INVERTDIRT_ON
				float4 staticSwitch126 = ( 1.0 - temp_output_116_0 );
			#else
				float4 staticSwitch126 = temp_output_116_0;
			#endif
			float4 lerpResult117 = lerp( staticSwitch129 , temp_cast_6 , staticSwitch126.r);
			float4 lerpResult121 = lerp( staticSwitch82 , _DirtColour , lerpResult117.r);
			o.Albedo = lerpResult121.rgb;
			float2 uv_EMIS = i.uv_texcoord * _EMIS_ST.xy + _EMIS_ST.zw;
			float3 hsvTorgb3_g8 = HSVToRGB( float3(_EMISColour,1.0,1.0) );
			o.Emission = ( ( tex2D( _EMIS, uv_EMIS ) * _EMISValue ) * float4( hsvTorgb3_g8 , 0.0 ) ).rgb;
			o.Metallic = tex2DNode3.b;
			float lerpResult122 = lerp( ( ( 1.0 - tex2DNode3.g ) * _RGHAmount ) , ( 1.0 - _DirtRoughness ) , lerpResult117.r);
			o.Smoothness = lerpResult122;
			float4 temp_cast_14 = (( tex2DNode3.r * _AOAmount )).xxxx;
			o.Occlusion = CalculateContrast(_AOContrast,temp_cast_14).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
-1915;33;918;1010;4437.44;2046.718;1.161099;True;False
Node;AmplifyShaderEditor.RangedFloatNode;75;-3832.17,-2950.266;Float;False;Property;_Hue;Hue;25;0;Create;True;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;84;-3510.575,-2919.32;Float;False;Simple HUE;-1;;7;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0.0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.SamplerNode;1;-3854.214,-2200.773;Float;True;Property;_ALB;ALB;4;0;Create;True;None;48c8f8256a67e6047bac084d3ea29c4c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;114;-3561.338,-1428.326;Float;False;Property;_DirtAmount;Dirt Amount;21;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-3636.51,-1900.061;Float;False;Property;_ALBSaturation;ALB Saturation;7;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-3291.907,-3029.099;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-3288.713,-2765.615;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-3290.311,-2878.994;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-3569.096,-1348.245;Float;False;Property;_DirtContrast;Dirt Contrast;22;0;Create;True;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;140;-3223.802,-1439.182;Float;False;1;0;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-3594.512,-76.56689;Float;True;Property;_ARM;ARM;0;0;Create;True;None;fbef3d3ffeabda842addb50d901a083c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;90;-2900.105,-2943.563;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-2825.518,905.8488;Float;False;Constant;_WindVertexMultiplier;Wind Vertex Multiplier;17;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;-3350.306,-1894.169;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;-2956.665,742.2745;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;49;-3113.952,480.5579;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-3048.677,-1482.732;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;139;-3226.402,-1361.183;Float;False;1;0;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-2935.623,-2729.05;Float;False;Property;_ColourSaturation;Colour Saturation;27;0;Create;True;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;11;-3178.197,-2065.292;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;67;-2724.517,1090.848;Float;False;Constant;_Vector0;Vector 0;17;0;Create;True;0,0,0,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-2555.517,887.8489;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ASinOpNode;59;-2638.218,742.0506;Float;False;1;0;FLOAT;2.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2727.742,-2560.539;Float;False;Property;_ColourBrightness;Colour Brightness;26;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-3110.894,-1969.11;Float;False;Property;_ALBBrightness;ALB Brightness;6;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-3259.668,-1570.441;Float;False;Property;_MaskContrast;Mask Contrast;17;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ASinOpNode;60;-2636.218,663.0505;Float;False;1;0;FLOAT;4.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;116;-2882.098,-1485.032;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;91;-2637.749,-2810.485;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;112;-3842.979,-1715.952;Float;True;Property;_DirtMask;Dirt Mask;16;0;Create;True;b236e0f35d7d74d4a881cd241d6c3997;b236e0f35d7d74d4a881cd241d6c3997;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;111;-3403.751,-933.4265;Float;False;Property;_DetailNRMIntensity;Detail NRM Intensity;11;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;107;-3718.806,-870.5202;Float;True;Property;_DetailNRM;Detail NRM;10;0;Create;True;8c22184997c1be741a7c29b4e745d187;6e97450ea182d3045ae2011b20f3864c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ASinOpNode;61;-2635.218,583.0505;Float;False;1;0;FLOAT;6.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-3759.882,-1116.746;Float;True;Property;_NRM;NRM;8;0;Create;True;None;6e97450ea182d3045ae2011b20f3864c;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-2438.86,-2608.744;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;39;-3868.445,-2469.265;Float;True;Property;_ColourMask;Colour Mask;24;0;Create;True;None;163c7d802dfde76419095b9e3643950d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-2364.517,888.8489;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT4;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;71;-2363.688,1107.378;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleContrastOpNode;134;-3033.053,-1659.949;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-3446.786,-1239.399;Float;False;Property;_NRMIntensity;NRM Intensity;9;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;138;-2751.9,-1350.732;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-2278.561,721.3113;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2899.882,-2070.911;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;130;-3123.311,-1859.827;Float;False;Constant;_Color0;Color 0;20;0;Create;True;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-2844.506,-1973.929;Float;False;Property;_ALBContrast;ALB Contrast;5;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;15;-2652.205,-2077.042;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;129;-2800.101,-1748.539;Float;False;Property;_DirtMaskSwitch;Dirt Mask Switch;15;0;Create;True;0;False;False;True;;Toggle;2;1;COLOR;0,0,0,0;False;0;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3182.67,-1227.284;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-2070.561,698.3112;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;119;-2647.553,-1593.392;Float;False;Constant;_black;black;17;0;Create;True;0;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-2482.885,-297.8762;Float;False;Property;_EMISColour;EMIS Colour;13;0;Create;True;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;-2254.546,-2433.155;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-3131.481,-883.7228;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-2112.013,885.3215;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3129.629,-123.5387;Float;False;Property;_AOAmount;AO Amount;2;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-3171.255,-1129.949;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;126;-2620.01,-1469.052;Float;False;Property;_InvertDirt;Invert Dirt;18;0;Create;True;0;False;False;True;;Toggle;2;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-2536.532,-403.1765;Float;False;Property;_EMISValue;EMIS Value;14;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;-2866.385,-515.9807;Float;True;Property;_EMIS;EMIS;12;0;Create;True;None;163c7d802dfde76419095b9e3643950d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-2884.242,285.319;Float;False;Property;_RGHAmount;RGH Amount;1;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-2867.672,146.1744;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-2769.89,45.94766;Float;False;Property;_DirtRoughness;Dirt Roughness;20;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-3142.895,-981.0582;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-2336.954,-441.5986;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;133;-2541.994,46.08722;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;117;-2382.841,-1640.253;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;108;-2717.73,-951.5987;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-2713.436,-1142.741;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-2549.119,137.7053;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;120;-2454.194,-1856.023;Float;False;Property;_DirtColour;Dirt Colour;19;0;Create;True;0.1985294,0.1725152,0.1488971,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-2708.892,-49.16199;Float;False;Property;_AOContrast;AO Contrast;3;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;97;-2301.193,-293.0995;Float;False;Simple HUE;-1;;8;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0.0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.StaticSwitch;82;-1795.394,-2090.834;Float;False;Property;_ColourMaskSwitch;Colour Mask Switch;23;0;Create;True;0;False;False;True;;Toggle;2;1;COLOR;0.0,0,0,0;False;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1969.472,464.3705;Float;False;Constant;_Float1;Float 1;17;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2690.241,-150.3362;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1910.834,750.5435;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT4;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;25;-2501.662,-155.6364;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-3048.113,-2535.917;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-2066.457,-347.9341;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-3048.944,-2337.389;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;-1510.64,-1749.42;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;122;-2185.152,81.94668;Float;False;3;0;FLOAT;0;False;1;FLOAT;0,0,0,0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;106;-2340.744,-1054.23;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-3047.57,-2437.421;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;50;-1745.474,469.3705;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0;False;2;FLOAT;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-36.6845,-825.5793;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;EnvironmentMaster_MM;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;84;1;75;0
WireConnection;102;0;1;1
WireConnection;102;1;84;7
WireConnection;103;0;1;3
WireConnection;103;1;84;8
WireConnection;101;0;1;2
WireConnection;101;1;84;5
WireConnection;140;0;114;0
WireConnection;90;0;102;0
WireConnection;90;1;101;0
WireConnection;90;2;103;0
WireConnection;34;0;12;0
WireConnection;115;0;3;1
WireConnection;115;1;140;0
WireConnection;139;0;113;0
WireConnection;11;0;1;0
WireConnection;11;1;34;0
WireConnection;69;0;49;1
WireConnection;69;1;70;0
WireConnection;59;0;52;0
WireConnection;60;0;52;0
WireConnection;116;1;115;0
WireConnection;116;0;139;0
WireConnection;91;0;90;0
WireConnection;91;1;92;0
WireConnection;61;0;52;0
WireConnection;104;0;91;0
WireConnection;104;1;105;0
WireConnection;68;0;69;0
WireConnection;68;1;67;0
WireConnection;134;1;112;0
WireConnection;134;0;137;0
WireConnection;138;0;116;0
WireConnection;62;0;60;0
WireConnection;62;1;59;0
WireConnection;13;0;11;0
WireConnection;13;1;14;0
WireConnection;15;1;13;0
WireConnection;15;0;23;0
WireConnection;129;1;130;0
WireConnection;129;0;134;0
WireConnection;18;0;2;1
WireConnection;18;1;20;0
WireConnection;63;0;61;0
WireConnection;63;1;62;0
WireConnection;29;0;1;0
WireConnection;29;1;104;0
WireConnection;29;2;39;1
WireConnection;109;0;107;2
WireConnection;109;1;111;0
WireConnection;66;0;68;0
WireConnection;66;1;71;0
WireConnection;19;0;2;2
WireConnection;19;1;20;0
WireConnection;126;1;116;0
WireConnection;126;0;138;0
WireConnection;4;0;3;2
WireConnection;110;0;107;1
WireConnection;110;1;111;0
WireConnection;46;0;100;0
WireConnection;46;1;47;0
WireConnection;133;0;132;0
WireConnection;117;0;129;0
WireConnection;117;1;119;0
WireConnection;117;2;126;0
WireConnection;108;0;110;0
WireConnection;108;1;109;0
WireConnection;108;2;107;3
WireConnection;17;0;18;0
WireConnection;17;1;19;0
WireConnection;17;2;2;3
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;97;1;96;0
WireConnection;82;1;15;0
WireConnection;82;0;29;0
WireConnection;21;0;3;1
WireConnection;21;1;22;0
WireConnection;64;0;63;0
WireConnection;64;1;66;0
WireConnection;25;1;21;0
WireConnection;25;0;26;0
WireConnection;87;0;1;1
WireConnection;87;1;84;7
WireConnection;99;0;46;0
WireConnection;99;1;97;6
WireConnection;89;0;84;8
WireConnection;89;1;1;3
WireConnection;121;0;82;0
WireConnection;121;1;120;0
WireConnection;121;2;117;0
WireConnection;122;0;5;0
WireConnection;122;1;133;0
WireConnection;122;2;117;0
WireConnection;106;0;17;0
WireConnection;106;1;108;0
WireConnection;88;0;84;5
WireConnection;88;1;1;2
WireConnection;50;0;51;0
WireConnection;50;1;64;0
WireConnection;50;2;49;1
WireConnection;0;0;121;0
WireConnection;0;1;106;0
WireConnection;0;2;99;0
WireConnection;0;3;3;3
WireConnection;0;4;122;0
WireConnection;0;5;25;0
WireConnection;0;11;50;0
ASEEND*/
//CHKSM=A8C35BDD450F00F2433C782582BF9844148998F9