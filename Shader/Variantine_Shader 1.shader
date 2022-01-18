Shader "Custom/Base_Shader"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _Feather ("Feather", Range(0,0.5))=0.05
        _Speed ("Speed", float)=2.3
        
    }
    SubShader
    {
        Tags { 
            "Order"="Transparent"
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
             }

        Pass {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform half4 _Color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _Feather;
            uniform float _Speed;

            struct VertexInput {
                float4 vertex:POSITION;
                float4 texcoord:TEXCOORD0;
            };

            struct VertexOutput {
                float4 pos: SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };
 
            float drawCircleAnimate(float2 uv, float2 center, float radius, float feather)
        {
            float circle=pow((uv.y-center.y),2)+pow((uv.x-center.x),2);
            float radiusSquare=pow(radius,2);
            if (circle<radiusSquare)
            {
                float fade=sin(_Time.y*_Speed);
                return smoothstep(radiusSquare, radiusSquare-feather,circle)*fade;
            }
            return 0;
        }


        VertexOutput vert(VertexInput v) {
            VertexOutput o;
            o.pos=UnityObjectToClipPos(v.vertex);
            o.texcoord.xy=(v.texcoord.xy* _MainTex_ST.xy+_MainTex_ST.zw);
            o.texcoord.zw = 0;
            return o;
        }

        half4 frag (VertexOutput i) : COLOR {
            float4 color=tex2D( _MainTex, i.texcoord) *_Color;
            color.xy=drawCircleAnimate(i.texcoord.y,0.4,0.35, 0.75);
            color.wz=drawCircleAnimate(i.texcoord.y,0.2,0.4, 0.75);
            
            return color;

        }

     
            ENDCG
        }
    }
}
