Shader "Custom/Smoothstep_Shader"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _Value("Value", float)=0.3
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
            uniform float4 _Value;

            struct VertexInput {
                float4 vertex:POSITION;
                float4 texcoord:TEXCOORD0;
            };

            struct VertexOutput {
                float4 pos: SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };

        float smoothstep(float4 lowervalue, float4 highervalue, float4 _Value) {
           
              
              float4 t;
              t=clamp((_Value - lowervalue) / (highervalue - lowervalue), 0.0, 1.0);
           
                return t * t * (3.0  -2.0 * t);
        }

 float drawLine (float2 uv, float start, float end) {
                if ((uv.x>start && uv.x<end)||(uv.y>start&&uv.y<end))
                {
                    return 1;
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
    
            _Value=i.texcoord;
            float4 color=tex2D(_MainTex, i.texcoord.xy)*_Color;
            color.y=smoothstep(0.0,1.8, i.texcoord.y/4)+drawLine(i.texcoord.x, 0.0, 1.0);
            color.a=smoothstep(0.0,1.0, color.y);
            return color+_Value;
        }

     
            ENDCG
        }
    }
}
