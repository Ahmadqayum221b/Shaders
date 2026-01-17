Shader "OutlineShader/Shader_03"
{
    Properties
    {
        _Color ("My Color",color) = (1,1,1,1)
        _OutlineColor("OutlineColor",color) = (0,0,0,1)
        _Brightness ("Brightness",Range(0,20)) = 5
        _BlinkSpeed ("BlinkSpeed",Float) = 2
        _OutlineRadius("OutlineRadius",Range(0,0.1)) = 0.03

    }
    SubShader
    {
        Tags {"RenderType" = "Opaque"}
        LOD 300
        //first pass for outlining.
        Pass
        {
            Cull Front
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            fixed4 _OutlineColor;
            float _Brightness;
            float _BlinkSpeed;
            float _OutlineRadius;
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL; //this will be for reading the normals.
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata vertexData)
            {
                v2f o;
                //for expanding the vertex.
                float3 expandedVertex = vertexData.vertex.xyz + vertexData.normal * _OutlineRadius;
                o.pos = UnityObjectToClipPos(float4(expandedVertex, 1));
                return o;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float blink = abs(sin(_Time.y * _BlinkSpeed));
                fixed4 color = _OutlineColor;
                color.rgb *= _Brightness * blink;
                return color;
            }
            ENDCG
        }
        //second pass for making the object again.
        Pass
        {
            Cull Back
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            fixed4 _Color;
            float _Brightness;
            float _BlinkSpeed;
            struct appdata
            {
                float4 vertex : POSITION;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata vertexData)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertexData.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return _Color;
            }


            ENDCG
        }
    }

}
