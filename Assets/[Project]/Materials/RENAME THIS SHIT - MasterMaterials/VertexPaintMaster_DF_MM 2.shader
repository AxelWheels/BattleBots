// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VertexPaintMaster_MM"
{
	Properties
	{
		_TileTexture2("Tile Texture2", Float) = 0.05
		_TileTexture3("Tile Texture3", Float) = 0.05
		_TileTexture4("Tile Texture4", Float) = 0.05
		_HRM2("HRM2", 2D) = "white" {}
		_RGH2Amount("RGH2 Amount", Float) = 1
		_HRM3("HRM3", 2D) = "white" {}
		_RGH3Amount("RGH3 Amount", Float) = 1
		_HRM4("HRM4", 2D) = "white" {}
		_RGH4Amount("RGH4 Amount", Float) = 1
		_ALB2("ALB2", 2D) = "white" {}
		_ALB2Brightness("ALB2 Brightness", Float) = 1
		_ALB2Contrast("ALB2 Contrast", Float) = 1
		_ALB2Saturation("ALB2 Saturation", Float) = 1
		_ALB3("ALB3", 2D) = "white" {}
		_ALB3Brightness("ALB3 Brightness", Float) = 1
		_ALB3contrast("ALB3 contrast", Float) = 1
		_ALB3Saturation("ALB3 Saturation", Float) = 1
		_ALB4("ALB4", 2D) = "white" {}
		_ALB4Brightness("ALB4 Brightness", Float) = 1
		_ALB4contrast("ALB4 contrast", Float) = 1
		_ALB4Saturation("ALB4 Saturation", Float) = 1
		_NRM2("NRM2", 2D) = "white" {}
		_NRM2Intensity("NRM2 Intensity", Float) = 1
		_NRM3("NRM3", 2D) = "white" {}
		_NRM3Intensity("NRM3 Intensity", Float) = 1
		_NRM4("NRM4", 2D) = "white" {}
		_NRM4Intensity("NRM4 Intensity", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _NRM2;
		uniform float _TileTexture2;
		uniform float _NRM2Intensity;
		uniform sampler2D _HRM2;
		uniform sampler2D _NRM3;
		uniform float _TileTexture3;
		uniform float _NRM3Intensity;
		uniform sampler2D _HRM3;
		uniform sampler2D _NRM4;
		uniform float _TileTexture4;
		uniform float _NRM4Intensity;
		uniform sampler2D _HRM4;
		uniform float _ALB2Contrast;
		uniform sampler2D _ALB2;
		uniform float _ALB2Saturation;
		uniform float _ALB2Brightness;
		uniform float _ALB3contrast;
		uniform sampler2D _ALB3;
		uniform float _ALB3Saturation;
		uniform float _ALB3Brightness;
		uniform float _ALB4contrast;
		uniform sampler2D _ALB4;
		uniform float _ALB4Saturation;
		uniform float _ALB4Brightness;
		uniform float _RGH2Amount;
		uniform float _RGH3Amount;
		uniform float _RGH4Amount;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult195 = (float2(_TileTexture2 , _TileTexture2));
			float2 temp_output_196_0 = ( (ase_worldPos).xz * appendResult195 );
			float3 tex2DNode171 = UnpackNormal( tex2D( _NRM2, temp_output_196_0 ) );
			float4 appendResult167 = (float4(( tex2DNode171.r * _NRM2Intensity ) , ( tex2DNode171.g * _NRM2Intensity ) , tex2DNode171.b , 0.0));
			float4 tex2DNode177 = tex2D( _HRM2, temp_output_196_0 );
			float temp_output_279_0 = ( 1.0 - tex2DNode177.r );
			float clampResult225 = clamp( ( i.vertexColor.r / temp_output_279_0 ) , 0.0 , 1.0 );
			float4 lerpResult147 = lerp( float4( 0,0,0,0 ) , appendResult167 , clampResult225);
			float2 appendResult200 = (float2(_TileTexture3 , _TileTexture3));
			float2 temp_output_201_0 = ( (ase_worldPos).xz * appendResult200 );
			float3 tex2DNode175 = UnpackNormal( tex2D( _NRM3, temp_output_201_0 ) );
			float4 appendResult172 = (float4(( tex2DNode175.r * _NRM3Intensity ) , ( tex2DNode175.g * _NRM3Intensity ) , tex2DNode175.b , 0.0));
			float4 tex2DNode185 = tex2D( _HRM3, temp_output_201_0 );
			float temp_output_280_0 = ( 1.0 - tex2DNode185.r );
			float clampResult229 = clamp( ( i.vertexColor.g / temp_output_280_0 ) , 0.0 , 1.0 );
			float4 lerpResult143 = lerp( lerpResult147 , appendResult172 , clampResult229);
			float2 appendResult256 = (float2(_TileTexture4 , _TileTexture4));
			float2 temp_output_258_0 = ( (ase_worldPos).xz * appendResult256 );
			float3 tex2DNode260 = UnpackNormal( tex2D( _NRM4, temp_output_258_0 ) );
			float4 appendResult263 = (float4(( tex2DNode260.r * _NRM4Intensity ) , ( tex2DNode260.g * _NRM4Intensity ) , tex2DNode260.b , 0.0));
			float4 tex2DNode269 = tex2D( _HRM4, temp_output_258_0 );
			float temp_output_281_0 = ( 1.0 - tex2DNode269.r );
			float clampResult232 = clamp( ( i.vertexColor.b / temp_output_281_0 ) , 0.0 , 1.0 );
			float4 lerpResult144 = lerp( lerpResult143 , appendResult263 , clampResult232);
			o.Normal = lerpResult144.xyz;
			float3 desaturateVar152 = lerp( tex2D( _ALB2, temp_output_196_0 ).rgb,dot(tex2D( _ALB2, temp_output_196_0 ).rgb,float3(0.299,0.587,0.114)).xxx,( 1.0 - _ALB2Saturation ));
			float4 lerpResult142 = lerp( float4( 0,0,0,0 ) , CalculateContrast(_ALB2Contrast,float4( ( desaturateVar152 * _ALB2Brightness ) , 0.0 )) , clampResult225);
			float3 desaturateVar159 = lerp( tex2D( _ALB3, temp_output_201_0 ).rgb,dot(tex2D( _ALB3, temp_output_201_0 ).rgb,float3(0.299,0.587,0.114)).xxx,( 1.0 - _ALB3Saturation ));
			float4 lerpResult145 = lerp( lerpResult142 , CalculateContrast(_ALB3contrast,float4( ( desaturateVar159 * _ALB3Brightness ) , 0.0 )) , clampResult229);
			float3 desaturateVar249 = lerp( tex2D( _ALB4, temp_output_258_0 ).rgb,dot(tex2D( _ALB4, temp_output_258_0 ).rgb,float3(0.299,0.587,0.114)).xxx,( 1.0 - _ALB4Saturation ));
			float4 lerpResult146 = lerp( lerpResult145 , CalculateContrast(_ALB4contrast,float4( ( desaturateVar249 * _ALB4Brightness ) , 0.0 )) , clampResult232);
			o.Albedo = lerpResult146.rgb;
			float lerpResult150 = lerp( 0.0 , ( ( 1.0 - tex2DNode177.g ) * _RGH2Amount ) , clampResult225);
			float lerpResult148 = lerp( lerpResult150 , ( ( 1.0 - tex2DNode185.g ) * _RGH3Amount ) , clampResult229);
			float lerpResult149 = lerp( lerpResult148 , ( ( 1.0 - tex2DNode269.g ) * _RGH4Amount ) , clampResult232);
			o.Smoothness = lerpResult149;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
8;30;1904;992;7789.057;2415.073;6.204028;True;True
Node;AmplifyShaderEditor.RangedFloatNode;197;-5027.924,-1156.661;Float;False;Property;_TileTexture2;Tile Texture2;1;0;Create;True;0.05;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;193;-5238.13,-1402.475;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;194;-4934.761,-1419.578;Float;False;True;False;True;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-5034.588,-623.9368;Float;False;Property;_TileTexture3;Tile Texture3;2;0;Create;True;0.05;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;198;-5244.794,-869.7539;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;195;-4942.496,-1297.733;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-3346.609,-2615.012;Float;False;Property;_ALB2Saturation;ALB2 Saturation;16;0;Create;True;1;0.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;-4681.417,-1408.732;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;200;-4949.158,-765.0122;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;254;-5089.234,-167.9441;Float;False;Property;_TileTexture4;Tile Texture4;3;0;Create;True;0.05;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;199;-4941.425,-886.8579;Float;False;True;False;True;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;255;-5299.44,-413.7612;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;-4688.081,-876.0109;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-3329.758,-2298.53;Float;False;Property;_ALB3Saturation;ALB3 Saturation;20;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;151;-3708.725,-2477.019;Float;True;Property;_ALB2;ALB2;13;0;Create;True;None;98268e0e6e0d4c647a49be4b1abbd273;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;177;-3693.969,745.3182;Float;True;Property;_HRM2;HRM2;7;0;Create;True;None;e267a1c7fda971b43ada68140ece376a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;257;-4996.071,-430.8652;Float;False;True;False;True;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;256;-5003.805,-309.0195;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;153;-3336.406,-2540.12;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;-4742.728,-420.0182;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;162;-3691.875,-2160.538;Float;True;Property;_ALB3;ALB3;17;0;Create;True;None;694dbf48b5f03bd44b39e3bdda422659;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;168;-3387.692,-963.6585;Float;False;Property;_NRM2Intensity;NRM2 Intensity;26;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-2898.309,-2604.791;Float;False;Property;_ALB2Brightness;ALB2 Brightness;14;0;Create;True;1;1.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;185;-3689.247,1032.376;Float;True;Property;_HRM3;HRM3;9;0;Create;True;None;265dd5f2dc830ef4b9be52febfb23fff;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;279;-3408.077,760.7502;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;-3325.803,-1989.605;Float;False;Property;_ALB4Saturation;ALB4 Saturation;24;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;152;-3343.296,-2470.243;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;171;-3713.103,-830.1948;Float;True;Property;_NRM2;NRM2;25;0;Create;True;None;1ae01118f64a6494c9fa89bb1ff23116;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;160;-3319.554,-2223.638;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;141;-2419.648,-757.213;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;164;-2881.458,-2288.31;Float;False;Property;_ALB3Brightness;ALB3 Brightness;18;0;Create;True;1;1.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-3367.765,-789.0178;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-3377.766,-538.9641;Float;False;Property;_NRM3Intensity;NRM3 Intensity;28;0;Create;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;248;-3315.599,-1914.713;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;175;-3703.177,-405.5;Float;True;Property;_NRM3;NRM3;27;0;Create;True;None;7f4c04b54b6d504408aa33010ea0baa8;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;269;-3689.27,1352.173;Float;True;Property;_HRM4;HRM4;11;0;Create;True;None;a9eceee62afbbd64cb15825ffda643a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;280;-3403.357,1047.808;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;282;-1694.5,-1038.61;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;180;-3251.422,791.7925;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-3255.993,859.9363;Float;False;Property;_RGH2Amount;RGH2 Amount;8;0;Create;True;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-2668.921,-2610.61;Float;False;Property;_ALB2Contrast;ALB2 Contrast;15;0;Create;True;1;1.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;159;-3326.445,-2153.762;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-2870.296,-2531.592;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-3370.594,-887.7838;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;247;-3687.92,-1851.613;Float;True;Property;_ALB4;ALB4;21;0;Create;True;None;98268e0e6e0d4c647a49be4b1abbd273;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;250;-2877.503,-1979.385;Float;False;Property;_ALB4Brightness;ALB4 Brightness;22;0;Create;True;1;1.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-3251.272,1146.996;Float;False;Property;_RGH3Amount;RGH3 Amount;10;0;Create;True;1;1.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;249;-3322.49,-1844.837;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;260;-3689.248,42.87576;Float;True;Property;_NRM4;NRM4;29;0;Create;True;None;7f4c04b54b6d504408aa33010ea0baa8;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;167;-3359.294,-690.1892;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;281;-3403.381,1367.605;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-3239.87,931.3227;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;283;-1690.257,-753.5553;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;186;-3246.702,1078.851;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;225;-1385.245,-1045.088;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;157;-2653.617,-2532.723;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-2652.07,-2294.128;Float;False;Property;_ALB3contrast;ALB3 contrast;19;0;Create;True;1;1.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-2853.445,-2215.111;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-3360.668,-463.0889;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;-3357.839,-364.3232;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;-3363.837,-90.58835;Float;False;Property;_NRM4Intensity;NRM4 Intensity;30;0;Create;True;1;-0.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;229;-1366.704,-764.3597;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;270;-3246.726,1398.648;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;172;-3349.368,-265.4947;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;284;-1687.657,-451.9554;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;142;-979.8956,-1616.455;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;271;-3251.295,1466.793;Float;False;Property;_RGH4Amount;RGH4 Amount;12;0;Create;True;1;1.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;251;-2648.115,-1985.203;Float;False;Property;_ALB4contrast;ALB4 contrast;23;0;Create;True;1;1.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-3235.148,1218.382;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;147;-951.9733,-977.9134;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;-2849.49,-1906.186;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-3343.91,84.05255;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-3346.739,-14.71313;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;150;-981.7716,-337.6019;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;165;-2636.765,-2216.242;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;272;-3235.171,1538.179;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;232;-1345.397,-515.7886;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;143;-750.6703,-814.5295;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;148;-800.4924,-165.2517;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;263;-3335.438,182.8811;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;253;-2632.81,-1907.317;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;145;-776.2884,-1462.46;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;100;-810.4696,1355.663;Float;True;Property;_EMIS1;EMIS1;31;0;Create;True;None;163c7d802dfde76419095b9e3643950d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.HeightMapBlendNode;220;-2153.897,-720.9864;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-10.54087,1523.708;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;97;-245.2773,1578.542;Float;False;Simple HUE;-1;;8;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0.0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.RangedFloatNode;273;-2179.61,-1003.246;Float;False;Property;_BlendStrength1;Blend Strength1;4;0;Create;True;1;-0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;274;-2155.275,-790.834;Float;False;Property;_BlendStrength2;Blend Strength2;5;0;Create;True;1;-0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-426.9688,1573.765;Float;False;Property;_EMISColour;EMIS Colour;32;0;Create;True;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;221;-2176.51,-513.362;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;275;-2164.56,-600.0959;Float;False;Property;_BlendStrength3;Blend Strength3;6;0;Create;True;1;-0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;218;-2181.685,-919.8635;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-4883.352,-1760.024;Float;False;Property;_TileTexture1;Tile Texture1;0;0;Create;True;0.05;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;189;-5093.558,-2005.839;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;191;-4797.921,-1901.098;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-4536.846,-2012.095;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;190;-4790.188,-2022.943;Float;False;True;False;True;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;144;-575.6199,-644.618;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;146;-612.6812,-1273.54;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-281.038,1430.044;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-480.6157,1468.466;Float;False;Property;_EMISValue;EMIS Value;33;0;Create;True;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;149;-648.1076,25.2155;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-36.6845,-825.5793;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;VertexPaintMaster_MM;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;194;0;193;0
WireConnection;195;0;197;0
WireConnection;195;1;197;0
WireConnection;196;0;194;0
WireConnection;196;1;195;0
WireConnection;200;0;202;0
WireConnection;200;1;202;0
WireConnection;199;0;198;0
WireConnection;201;0;199;0
WireConnection;201;1;200;0
WireConnection;151;1;196;0
WireConnection;177;1;196;0
WireConnection;257;0;255;0
WireConnection;256;0;254;0
WireConnection;256;1;254;0
WireConnection;153;0;154;0
WireConnection;258;0;257;0
WireConnection;258;1;256;0
WireConnection;162;1;201;0
WireConnection;185;1;201;0
WireConnection;279;0;177;1
WireConnection;152;0;151;0
WireConnection;152;1;153;0
WireConnection;171;1;196;0
WireConnection;160;0;161;0
WireConnection;169;0;171;2
WireConnection;169;1;168;0
WireConnection;248;0;246;0
WireConnection;175;1;201;0
WireConnection;269;1;258;0
WireConnection;280;0;185;1
WireConnection;282;0;141;1
WireConnection;282;1;279;0
WireConnection;180;0;177;2
WireConnection;159;0;162;0
WireConnection;159;1;160;0
WireConnection;155;0;152;0
WireConnection;155;1;156;0
WireConnection;170;0;171;1
WireConnection;170;1;168;0
WireConnection;247;1;258;0
WireConnection;249;0;247;0
WireConnection;249;1;248;0
WireConnection;260;1;258;0
WireConnection;167;0;170;0
WireConnection;167;1;169;0
WireConnection;167;2;171;3
WireConnection;281;0;269;1
WireConnection;178;0;180;0
WireConnection;178;1;179;0
WireConnection;283;0;141;2
WireConnection;283;1;280;0
WireConnection;186;0;185;2
WireConnection;225;0;282;0
WireConnection;157;1;155;0
WireConnection;157;0;158;0
WireConnection;166;0;159;0
WireConnection;166;1;164;0
WireConnection;174;0;175;1
WireConnection;174;1;176;0
WireConnection;173;0;175;2
WireConnection;173;1;176;0
WireConnection;229;0;283;0
WireConnection;270;0;269;2
WireConnection;172;0;174;0
WireConnection;172;1;173;0
WireConnection;172;2;175;3
WireConnection;284;0;141;3
WireConnection;284;1;281;0
WireConnection;142;1;157;0
WireConnection;142;2;225;0
WireConnection;187;0;186;0
WireConnection;187;1;184;0
WireConnection;147;1;167;0
WireConnection;147;2;225;0
WireConnection;252;0;249;0
WireConnection;252;1;250;0
WireConnection;262;0;260;2
WireConnection;262;1;259;0
WireConnection;261;0;260;1
WireConnection;261;1;259;0
WireConnection;150;1;178;0
WireConnection;150;2;225;0
WireConnection;165;1;166;0
WireConnection;165;0;163;0
WireConnection;272;0;270;0
WireConnection;272;1;271;0
WireConnection;232;0;284;0
WireConnection;143;0;147;0
WireConnection;143;1;172;0
WireConnection;143;2;229;0
WireConnection;148;0;150;0
WireConnection;148;1;187;0
WireConnection;148;2;229;0
WireConnection;263;0;261;0
WireConnection;263;1;262;0
WireConnection;263;2;260;3
WireConnection;253;1;252;0
WireConnection;253;0;251;0
WireConnection;145;0;142;0
WireConnection;145;1;165;0
WireConnection;145;2;229;0
WireConnection;220;1;280;0
WireConnection;220;2;274;0
WireConnection;99;0;46;0
WireConnection;99;1;97;6
WireConnection;97;1;96;0
WireConnection;221;1;281;0
WireConnection;221;2;275;0
WireConnection;218;1;279;0
WireConnection;218;2;273;0
WireConnection;191;0;188;0
WireConnection;191;1;188;0
WireConnection;192;0;190;0
WireConnection;192;1;191;0
WireConnection;190;0;189;0
WireConnection;144;0;143;0
WireConnection;144;1;263;0
WireConnection;144;2;232;0
WireConnection;146;0;145;0
WireConnection;146;1;253;0
WireConnection;146;2;232;0
WireConnection;46;0;100;0
WireConnection;46;1;47;0
WireConnection;149;0;148;0
WireConnection;149;1;272;0
WireConnection;149;2;232;0
WireConnection;0;0;146;0
WireConnection;0;1;144;0
WireConnection;0;4;149;0
ASEEND*/
//CHKSM=65F2EB984ABD730D2A594D7FC8D6C437D9C2F8AB