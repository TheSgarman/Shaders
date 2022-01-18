Shader "Custom/Circle_Shader"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _Center ("Center", Float)=0.5
        _Radius ("Radius", Float)=0.5
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

            uniform half4 _Color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float4 _Radius;
            uniform float4 _Center;

            struct VertexInput {
                float4 vertex:POSITION;
                float4 texcoord:TEXCOORD0;
            };

            struct VertexOutput {
                float4 pos: SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };


        
        float drawCircle(float2 uv, float2 center, float radius)
        {
            float circle=pow((uv.y-center.y),2)+pow((uv.x-center.x),2);
            float radiusSquare=pow(radius,2);
            if (circle<radiusSquare)
            {
                return 1;
            }
            return 0;
        }

        VertexOutput vert(VertexInput v) {
            VertexOutput o;
            o.pos=UnityObjectToClipPos(v.vertex);
            o.texcoord.xy=(v.texcoord.xy* _MainTex_ST.xyzw);
            o.texcoord.zw = 0;
            return o;
        }


        half4 frag (VertexOutput i) : COLOR {
            float4 color=tex2D(_MainTex, i.texcoord)*_Color;
        
            color.a=drawCircle(i.texcoord.y,0.0,1.0);
            return color;
            
        }

     
            ENDCG
        }
    }
}
