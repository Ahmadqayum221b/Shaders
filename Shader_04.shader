Shader "MyCustomShader/Shader_04"
{
    Properties
    {
        _FirstColor("First Color",color) = (0,1,0,1)
        _SecondColor("Second Color",color) = (1,0,0,1)
        _Opacity ("Brightness",Range(0,20)) = 5
        _BlinkSpeed ("BlinkSpeed",Float) = 2
        _ColorChangeRate ("Color Change Rate",Float) = 1
        _ScaleChangeRate("Scale Change Rate",Float) = 1
        _OffsetVal("Offset Value of Scaling",Float) = 1
    }
    SubShader
    {
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}
        LOD 150
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _FirstColor;
            fixed4 _SecondColor;
            float _Opacity;
            float _BlinkSpeed;
            float _ColorChangeRate;
            float _ScaleChangeRate;
            float _OffsetVal;
            struct appdata
            {
                float4 vertex : POSITION;//all the vertex position will go here.
            };

            struct v2f 
            {
                float4 pos : SV_POSITION; //this is basically the final position that we are giving to the position variable.
            };

            v2f vert(appdata vertexData)
            {
                v2f o;
                float4 scaleVertex = vertexData.vertex;
                float ChangingFactor = sin(_ScaleChangeRate * _Time.y) * 0.5 + 0.5;
                scaleVertex.xyz = lerp(scaleVertex.xyz, scaleVertex.xyz * _OffsetVal, ChangingFactor);
                o.pos = UnityObjectToClipPos(scaleVertex);
                
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float ChangingFactor = sin(_ColorChangeRate * _Time.y) * 0.5f;
                fixed4 finalColor = lerp(_FirstColor,_SecondColor,ChangingFactor);
                float blinkRate = abs(sin(_Time.y * _BlinkSpeed));
                finalColor.rgb *= _Opacity;
                
                return finalColor;
            }
            ENDCG
        }
    }
}