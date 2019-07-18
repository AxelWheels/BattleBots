// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "waterMaster_DF_MM"
{
	Properties
	{
		_DeepColour("Deep Colour", Color) = (0,0.3155172,0.75,0)
		_AO("AO", Range( 0 , 1)) = 0.5
		_NormalIntensity("Normal Intensity", Float) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.8
		_MTL("MTL", Range( 0 , 1)) = 0.8
		_ShallowColour("Shallow Colour", Color) = (0.1124567,0.3906929,0.5882353,0)
		_TileNormal2("Tile Normal2", Float) = 0.01
		_DistortionValue("Distortion Value", Float) = 0.3
		_TileNormal1("Tile Normal1", Float) = 0.05
		_Normal1("Normal1", 2D) = "bump" {}
		_Normal2("Normal2", 2D) = "bump" {}
		_DepthPower("Depth Power", Float) = -3.6
		_waterDepth("water Depth", Float) = 0.9
		_Opacity("Opacity", Float) = 0.5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float _NormalIntensity;
		uniform sampler2D _Normal1;
		uniform float _TileNormal1;
		uniform sampler2D _Normal2;
		uniform float _TileNormal2;
		uniform sampler2D _GrabTexture;
		uniform float _DistortionValue;
		uniform float4 _ShallowColour;
		uniform float4 _DeepColour;
		uniform sampler2D _CameraDepthTexture;
		uniform float _waterDepth;
		uniform float _DepthPower;
		uniform float _Opacity;
		uniform float _MTL;
		uniform float _Smoothness;
		uniform float _AO;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_82_0 = (ase_worldPos).xz;
			float2 appendResult85 = (float2(_TileNormal1 , _TileNormal1));
			float2 temp_output_96_0 = ( temp_output_82_0 * appendResult85 );
			float2 panner54 = ( temp_output_96_0 + 1.0 * _Time.y * float2( 0.02,0.01 ));
			float2 appendResult86 = (float2(_TileNormal2 , _TileNormal2));
			float2 temp_output_98_0 = ( temp_output_82_0 * appendResult86 );
			float2 panner55 = ( temp_output_98_0 + 1.0 * _Time.y * float2( 0.05,0.01 ));
			float3 temp_output_57_0 = BlendNormals( UnpackScaleNormal( tex2D( _Normal1, panner54 ) ,_NormalIntensity ) , UnpackScaleNormal( tex2D( _Normal2, panner55 ) ,_NormalIntensity ) );
			o.Normal = temp_output_57_0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 appendResult62 = (float4(ase_screenPosNorm.x , ase_screenPosNorm.y , 0.0 , 0.0));
			float4 screenColor67 = tex2D( _GrabTexture, ( ( appendResult62 / ase_screenPosNorm.w ) + float4( ( _DistortionValue * _DistortionValue * temp_output_57_0 ) , 0.0 ) ).xy );
			float3 appendResult78 = (float3(_ShallowColour.r , _ShallowColour.g , _ShallowColour.b));
			float3 appendResult79 = (float3(_DeepColour.r , _DeepColour.g , _DeepColour.b));
			float eyeDepth44 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float3 lerpResult49 = lerp( appendResult78 , appendResult79 , pow( ( abs( ( eyeDepth44 - ase_screenPos.w ) ) + _waterDepth ) , _DepthPower ));
			float4 lerpResult68 = lerp( screenColor67 , float4( lerpResult49 , 0.0 ) , _Opacity);
			o.Albedo = lerpResult68.rgb;
			o.Metallic = _MTL;
			o.Smoothness = _Smoothness;
			o.Occlusion = _AO;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
1704;55;1783;996;4896.489;449.3114;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;74;-4212.343,98.32592;Float;False;Property;_TileNormal2;Tile Normal2;6;0;Create;True;0.01;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-4212.225,17.23195;Float;False;Property;_TileNormal1;Tile Normal1;8;0;Create;True;0.05;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;80;-4422.43,-228.5853;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;82;-4119.061,-245.6894;Float;False;True;False;True;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;86;-4036.824,266.0625;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;85;-4126.795,-123.8436;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-3865.72,-234.8419;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-3853.723,238.459;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;43;-2968.342,729.5504;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;54;-3372.304,-36.7307;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.02,0.01;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;55;-3367.904,178.6691;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0.01;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-3001.427,-113.6525;Float;False;Property;_NormalIntensity;Normal Intensity;2;0;Create;True;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;44;-2757.261,645.2004;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;60;-2216.784,-467.5588;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;52;-3044.746,144.1037;Float;True;Property;_Normal2;Normal2;10;0;Create;True;dd2fd2df93418444c8e280f1d34deeb5;fb6566c21f717904f83743a5a76dd0b0;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;53;-3045.764,-33.23975;Float;True;Property;_Normal1;Normal1;9;0;Create;True;fb6566c21f717904f83743a5a76dd0b0;fb6566c21f717904f83743a5a76dd0b0;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;45;-2619.932,804.652;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;46;-2430.764,807.1693;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;57;-2662.127,70.11681;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2272.691,-275.4952;Float;False;Property;_DistortionValue;Distortion Value;7;0;Create;True;0.3;1.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;62;-1961.637,-493.3493;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-2415.558,890.6876;Float;False;Property;_waterDepth;water Depth;12;0;Create;True;0.9;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2431.557,1002.687;Float;False;Property;_DepthPower;Depth Power;11;0;Create;True;-3.6;0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;63;-1938.637,-329.3503;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;47;-2435.936,597.0587;Float;False;Property;_DeepColour;Deep Colour;0;0;Create;True;0,0.3155172,0.75,0;0.3007136,0.6364779,0.7573529,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-2201.194,848.5078;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-2017.787,-192.6787;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT3;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;48;-2438.993,420.6376;Float;False;Property;_ShallowColour;Shallow Colour;5;0;Create;True;0.1124567,0.3906929,0.5882353,0;0.5254109,0.7929618,0.8308824,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;78;-2080.119,547.7569;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;73;-2109.709,957.6503;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;79;-2081.718,707.757;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-1703,-313.5882;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1508.415,-132.3658;Float;False;Property;_Opacity;Opacity;13;0;Create;True;0.5;0.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;49;-1759.601,748.473;Float;False;3;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0.0,0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenColorNode;67;-1517.748,-310.0349;Float;False;Global;_GrabScreen0;Grab Screen 0;2;0;Create;True;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-1011.415,147.5606;Float;False;Property;_MTL;MTL;4;0;Create;True;0.8;0.36;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;68;-1205.391,-289.2626;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-3593.1,475.1679;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-3595.373,690.4667;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;50,50;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-1011.818,309.6009;Float;False;Property;_AO;AO;1;0;Create;True;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1009.3,229.9013;Float;False;Property;_Smoothness;Smoothness;3;0;Create;True;0.8;0.97;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-595.7311,23.45823;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;waterMaster_DF_MM;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;False;0;Transparent;0.5;True;False;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;82;0;80;0
WireConnection;86;0;74;0
WireConnection;86;1;74;0
WireConnection;85;0;75;0
WireConnection;85;1;75;0
WireConnection;96;0;82;0
WireConnection;96;1;85;0
WireConnection;98;0;82;0
WireConnection;98;1;86;0
WireConnection;54;0;96;0
WireConnection;55;0;98;0
WireConnection;44;0;43;0
WireConnection;52;1;55;0
WireConnection;52;5;56;0
WireConnection;53;1;54;0
WireConnection;53;5;56;0
WireConnection;45;0;44;0
WireConnection;45;1;43;4
WireConnection;46;0;45;0
WireConnection;57;0;53;0
WireConnection;57;1;52;0
WireConnection;62;0;60;1
WireConnection;62;1;60;2
WireConnection;63;0;62;0
WireConnection;63;1;60;4
WireConnection;72;0;46;0
WireConnection;72;1;70;0
WireConnection;66;0;65;0
WireConnection;66;1;65;0
WireConnection;66;2;57;0
WireConnection;78;0;48;1
WireConnection;78;1;48;2
WireConnection;78;2;48;3
WireConnection;73;0;72;0
WireConnection;73;1;71;0
WireConnection;79;0;47;1
WireConnection;79;1;47;2
WireConnection;79;2;47;3
WireConnection;64;0;63;0
WireConnection;64;1;66;0
WireConnection;49;0;78;0
WireConnection;49;1;79;0
WireConnection;49;2;73;0
WireConnection;67;0;64;0
WireConnection;68;0;67;0
WireConnection;68;1;49;0
WireConnection;68;2;76;0
WireConnection;59;0;96;0
WireConnection;50;0;98;0
WireConnection;0;0;68;0
WireConnection;0;1;57;0
WireConnection;0;3;36;0
WireConnection;0;4;77;0
WireConnection;0;5;69;0
ASEEND*/
//CHKSM=F43512EC2AB0A7ED1ED2426AB20C6322E236C0BE