// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PropMasterTwoSided_MM"
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
		_EMIS("EMIS", 2D) = "black" {}
		_EMISValue("EMIS Value", Float) = 1
		_EMISColour("EMIS Colour", Float) = 0
		[Toggle] _ColourMaskSwitch("Colour Mask Switch", Float) = 0.0
		_ColourMask("Colour Mask", 2D) = "black" {}
		_Hue("Hue", Range( 0 , 1)) = 0.5
		_ColourBrightness("Colour Brightness", Float) = 1
		_ColourSaturation("Colour Saturation", Float) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _COLOURMASKSWITCH_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NRM;
		uniform float4 _NRM_ST;
		uniform float _NRMIntensity;
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
		uniform sampler2D _EMIS;
		uniform float4 _EMIS_ST;
		uniform float _EMISValue;
		uniform float _EMISColour;
		uniform sampler2D _ARM;
		uniform float4 _ARM_ST;
		uniform float _RGHAmount;
		uniform float _AOContrast;
		uniform float _AOAmount;
		uniform float _Cutoff = 0.5;


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
			o.Normal = appendResult17.xyz;
			float2 uv_ALB = i.uv_texcoord * _ALB_ST.xy + _ALB_ST.zw;
			float4 tex2DNode1 = tex2D( _ALB, uv_ALB );
			float3 desaturateVar11 = lerp( tex2DNode1.rgb,dot(tex2DNode1.rgb,float3(0.299,0.587,0.114)).xxx,( 1.0 - _ALBSaturation ));
			float3 hsvTorgb3_g7 = HSVToRGB( float3(_Hue,1.0,1.0) );
			float temp_output_84_7 = hsvTorgb3_g7.x;
			float temp_output_84_5 = hsvTorgb3_g7.y;
			float temp_output_84_8 = hsvTorgb3_g7.z;
			float4 appendResult90 = (float4(( tex2DNode1.r * temp_output_84_7 ) , ( tex2DNode1.g * temp_output_84_5 ) , ( tex2DNode1.b * temp_output_84_8 ) , 0.0));
			float3 desaturateVar91 = lerp( appendResult90.xyz,dot(appendResult90.xyz,float3(0.299,0.587,0.114)).xxx,( 1.0 - _ColourSaturation ));
			float2 uv_ColourMask = i.uv_texcoord * _ColourMask_ST.xy + _ColourMask_ST.zw;
			float4 lerpResult29 = lerp( tex2DNode1 , float4( ( desaturateVar91 * _ColourBrightness ) , 0.0 ) , tex2D( _ColourMask, uv_ColourMask ).r);
			#ifdef _COLOURMASKSWITCH_ON
				float4 staticSwitch82 = lerpResult29;
			#else
				float4 staticSwitch82 = CalculateContrast(_ALBContrast,float4( ( desaturateVar11 * _ALBBrightness ) , 0.0 ));
			#endif
			o.Albedo = staticSwitch82.rgb;
			float2 uv_EMIS = i.uv_texcoord * _EMIS_ST.xy + _EMIS_ST.zw;
			float3 hsvTorgb3_g8 = HSVToRGB( float3(_EMISColour,1.0,1.0) );
			o.Emission = ( ( tex2D( _EMIS, uv_EMIS ) * _EMISValue ) * float4( hsvTorgb3_g8 , 0.0 ) ).rgb;
			float2 uv_ARM = i.uv_texcoord * _ARM_ST.xy + _ARM_ST.zw;
			float4 tex2DNode3 = tex2D( _ARM, uv_ARM );
			o.Metallic = tex2DNode3.b;
			o.Smoothness = ( ( 1.0 - tex2DNode3.g ) * _RGHAmount );
			float4 temp_cast_8 = (( tex2DNode3.r * _AOAmount )).xxxx;
			o.Occlusion = CalculateContrast(_AOContrast,temp_cast_8).r;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
2119;67;1585;900;4525.954;3833.742;4.379186;True;True
Node;AmplifyShaderEditor.RangedFloatNode;75;-3079.412,-2700.781;Float;False;Property;_Hue;Hue;15;0;Create;True;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;84;-2757.817,-2669.835;Float;False;Simple HUE;-1;;7;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0.0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.SamplerNode;1;-3114.456,-1950.288;Float;True;Property;_ALB;ALB;4;0;Create;True;None;48c8f8256a67e6047bac084d3ea29c4c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-2883.752,-1650.576;Float;False;Property;_ALBSaturation;ALB Saturation;7;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-2535.955,-2516.13;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-2537.553,-2629.509;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-2539.149,-2779.614;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1981.633,227.7783;Float;False;Constant;_WindVertexMultiplier;Wind Vertex Multiplier;17;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;-2112.78,64.20396;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;49;-2270.067,-199.9017;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;92;-2279.865,-2438.565;Float;False;Property;_ColourSaturation;Colour Saturation;17;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;-2597.548,-1644.684;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;67;-1880.633,412.7783;Float;False;Constant;_Vector0;Vector 0;17;0;Create;True;0,0,0,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ASinOpNode;59;-1794.334,63.98005;Float;False;1;0;FLOAT;2.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;90;-2147.347,-2694.078;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1711.633,209.7783;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ASinOpNode;60;-1792.334,-15.01996;Float;False;1;0;FLOAT;4.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;106;-2059.973,-2443.271;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;11;-2425.439,-1815.808;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DesaturateOpNode;91;-1884.991,-2561;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-1434.677,43.24075;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;71;-1519.804,429.3074;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;105;-1974.984,-2311.054;Float;False;Property;_ColourBrightness;Colour Brightness;16;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1520.633,210.7783;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT4;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2358.136,-1719.625;Float;False;Property;_ALBBrightness;ALB Brightness;6;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ASinOpNode;61;-1791.334,-95.01996;Float;False;1;0;FLOAT;6.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;-1965.458,-1045.536;Float;True;Property;_EMIS;EMIS;10;0;Create;True;None;163c7d802dfde76419095b9e3643950d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-2683.584,-693.5115;Float;True;Property;_ARM;ARM;0;0;Create;True;None;fbef3d3ffeabda842addb50d901a083c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;96;-1571.958,-912.4317;Float;False;Property;_EMISColour;EMIS Colour;12;0;Create;True;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2147.124,-1821.426;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;39;-3070.807,-2235.013;Float;True;Property;_ColourMask;Colour Mask;14;0;Create;True;None;163c7d802dfde76419095b9e3643950d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-1686.102,-2359.259;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;2;-2593.069,-1255.993;Float;True;Property;_NRM;NRM;8;0;Create;True;None;6e97450ea182d3045ae2011b20f3864c;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;-1625.605,-1017.732;Float;False;Property;_EMISValue;EMIS Value;11;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-1226.677,20.24075;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1268.129,207.2509;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2218.702,-738.0943;Float;False;Property;_AOAmount;AO Amount;2;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2091.748,-1724.444;Float;False;Property;_ALBContrast;ALB Contrast;5;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2301.704,-1337.598;Float;False;Property;_NRMIntensity;NRM Intensity;9;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;97;-1390.266,-907.655;Float;False;Simple HUE;-1;;8;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0.0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.RangedFloatNode;26;-1797.965,-663.7175;Float;False;Property;_AOContrast;AO Contrast;3;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-2010.015,-574.0881;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2030.344,-1347.215;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2018.929,-1249.88;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2026.585,-434.9434;Float;False;Property;_RGHAmount;RGH Amount;1;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;15;-1899.447,-1827.558;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1125.588,-213.7;Float;False;Constant;_Float1;Float 1;17;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1066.95,72.47295;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT4;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;29;-1501.788,-2183.67;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1426.027,-1056.154;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1779.314,-764.8918;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;82;-805.0271,-1967.5;Float;False;Property;_ColourMaskSwitch;Colour Mask Switch;13;0;Create;True;0;False;False;True;;Toggle;2;1;COLOR;0.0,0,0,0;False;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1155.53,-962.4895;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;25;-1590.735,-770.192;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-2294.812,-2187.936;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-2295.355,-2286.432;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1517.644,-1257.842;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;50;-901.5881,-208.7;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0;False;2;FLOAT;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-2296.186,-2087.904;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1691.46,-582.5571;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-36.6845,-825.5793;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;PropMasterTwoSided_MM;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;0;False;0;0;False;0;Custom;0.5;True;True;0;True;TransparentCutout;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;18;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;84;1;75;0
WireConnection;103;0;1;3
WireConnection;103;1;84;8
WireConnection;101;0;1;2
WireConnection;101;1;84;5
WireConnection;102;0;1;1
WireConnection;102;1;84;7
WireConnection;34;0;12;0
WireConnection;59;0;52;0
WireConnection;90;0;102;0
WireConnection;90;1;101;0
WireConnection;90;2;103;0
WireConnection;69;0;49;1
WireConnection;69;1;70;0
WireConnection;60;0;52;0
WireConnection;106;0;92;0
WireConnection;11;0;1;0
WireConnection;11;1;34;0
WireConnection;91;0;90;0
WireConnection;91;1;106;0
WireConnection;62;0;60;0
WireConnection;62;1;59;0
WireConnection;68;0;69;0
WireConnection;68;1;67;0
WireConnection;61;0;52;0
WireConnection;13;0;11;0
WireConnection;13;1;14;0
WireConnection;104;0;91;0
WireConnection;104;1;105;0
WireConnection;63;0;61;0
WireConnection;63;1;62;0
WireConnection;66;0;68;0
WireConnection;66;1;71;0
WireConnection;97;1;96;0
WireConnection;4;0;3;2
WireConnection;18;0;2;1
WireConnection;18;1;20;0
WireConnection;19;0;2;2
WireConnection;19;1;20;0
WireConnection;15;1;13;0
WireConnection;15;0;23;0
WireConnection;64;0;63;0
WireConnection;64;1;66;0
WireConnection;29;0;1;0
WireConnection;29;1;104;0
WireConnection;29;2;39;1
WireConnection;46;0;100;0
WireConnection;46;1;47;0
WireConnection;21;0;3;1
WireConnection;21;1;22;0
WireConnection;82;1;15;0
WireConnection;82;0;29;0
WireConnection;99;0;46;0
WireConnection;99;1;97;6
WireConnection;25;1;21;0
WireConnection;25;0;26;0
WireConnection;88;0;84;5
WireConnection;88;1;1;2
WireConnection;87;0;1;1
WireConnection;87;1;84;7
WireConnection;17;0;18;0
WireConnection;17;1;19;0
WireConnection;17;2;2;3
WireConnection;50;0;51;0
WireConnection;50;1;64;0
WireConnection;50;2;49;1
WireConnection;89;0;84;8
WireConnection;89;1;1;3
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;0;0;82;0
WireConnection;0;1;17;0
WireConnection;0;2;99;0
WireConnection;0;3;3;3
WireConnection;0;4;5;0
WireConnection;0;5;25;0
WireConnection;0;10;1;4
WireConnection;0;11;50;0
ASEEND*/
//CHKSM=CDBDEAAA0637019FA57AF6C6FA0C2761B22245BF