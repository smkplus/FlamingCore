// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Smkgames/worldSpaceFade" {
    Properties {
        [HDR] _Color ("Color", Color) = (1,1,1,1)
        _MaskRadius("MaskRadius",Float) = 1
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _GlowMap ("GlowMap", 2D) = "white" {}
        _MaskTex ("MaskTex",2D) = "white" {}
        _NormalMap("Normal Map",2D) = "bump" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        
        _Amplitude("Amplitude", Float) = 0
		_Frequency("Frequency", Float) = 0
		_OffsetSin("OffsetSin", Float) = 0
    }
    SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _MaskTex;

        struct Input {
            float2 uv_MainTex;
            float2 uv_MaskTex;
            float3 worldPos: TEXCOORD2; // using world position
        };

        half _Glossiness;
        half _Metallic;
        half _MaskRadius;
        fixed4 _Color;

        uniform float _OffsetSin;
		uniform float _Frequency;
		uniform float _Amplitude;

        uniform float4 _arrayPosition [5]; // declare array position 
        uniform float _arraySize [5]; // declare array size 
        uniform float _maskAlpha[5];
        sampler2D _GlowMap;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)
        
        void vert (inout appdata_full v, out Input o){
            UNITY_INITIALIZE_OUTPUT(Input,o);
            o.worldPos = mul(unity_ObjectToWorld, v.vertex); // calculating world position in vertex shader
                     float4 color = float4(0,0,0,0); // temp color for using in alpha

         for(int i = 0; i < 5;i++){
             float dist = distance(o.worldPos, 
               float4(_arrayPosition[i].xyz, 1.0)); // calculate distance in world position
                _arraySize[i] /= 2;
               color += smoothstep(_arraySize[i]+_MaskRadius,_arraySize[i],dist)*_maskAlpha[i]; // sum result of dynamic masks
            }
//            float value = ( sin( ( _OffsetSin + ( v.vertex.x * _Frequency ) ) ) * _Amplitude );
//            float4 result = float4(0.0 , 0.0 ,value, 0.0);
			v.vertex.z += color/2;
			
//            v.vertex.xyz += color.rgb * v.normal.rgb/2;
        }
        void surf (Input IN, inout SurfaceOutputStandard o) {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) ;
            float4 mask = tex2D(_MaskTex,IN.uv_MaskTex);


         float4 color = float4(0,0,0,0); // temp color for using in alpha

         for(int i = 0; i < 5;i++){
             float dist = distance(IN.worldPos, 
               float4(_arrayPosition[i].xyz, 1.0)); // calculate distance in world position

                _arraySize[i] /= 2;
                // if distance is smaller than size of each object result is white in mask
               color += smoothstep(_arraySize[i]+_MaskRadius,_arraySize[i],dist)*_maskAlpha[i]; // sum result of dynamic masks
               
            }

            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Emission = lerp(0,mask,color*_Color)+tex2D(_GlowMap,IN.uv_MainTex);
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
    }