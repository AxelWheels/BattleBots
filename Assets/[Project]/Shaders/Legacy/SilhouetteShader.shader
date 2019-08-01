Shader "Onyx/Silhouette"
{
	Properties
	{
		_OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
	}

    SubShader 
    {
        ZWrite Off
        ZTest Always
        Lighting Off
        Pass
        {
            CGPROGRAM
            #pragma vertex VShader
            #pragma fragment FShader
 
			half4 _OutlineColor;

            struct VertexToFragment
            {
                float4 pos:POSITION;
            };
 
            VertexToFragment VShader(VertexToFragment i)
            {
                VertexToFragment o;
                o.pos=UnityObjectToClipPos(i.pos);
                return o;
            }
 
            //Return colour
            half4 FShader():COLOR0
            {
				return _OutlineColor;
            }
 
            ENDCG
        }
    }
}