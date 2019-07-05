// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX_Floor"
{
	Properties
	{
		_Color0("Color 0", Color) = (0.25,0.25,0.25,0)
		_Roughness("Roughness", Range( 0 , 1)) = 0
		_Metal("Metal", Float) = 0
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
			fixed filler;
		};

		uniform float4 _Color0;
		uniform float _Metal;
		uniform float _Roughness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color0.rgb;
			o.Metallic = _Metal;
			o.Smoothness = ( 1.0 - _Roughness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
2653;452;1722;915;861;457.5;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;2;-534,-47.5;Float;False;Property;_Roughness;Roughness;1;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-505,-252.5;Float;False;Property;_Color0;Color 0;0;0;Create;True;0.25,0.25,0.25,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;3;-266,-42.5;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-220,-129.5;Float;False;Property;_Metal;Metal;2;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-8,-206;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;VFX_Floor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;0;0;1;0
WireConnection;0;3;4;0
WireConnection;0;4;3;0
ASEEND*/
//CHKSM=B2FCEA61CB2232B7B11F62883D139AE93A36D78C