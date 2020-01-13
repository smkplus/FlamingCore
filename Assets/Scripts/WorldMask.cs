using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[ExecuteInEditMode]
public class WorldMask : MonoBehaviour
{
    public Transform[] arrayTransform;
    [HideInInspector] public  Vector4[] arrayPosition;
    public Ball[] balls;
    public float[] arraySize;
    [HideInInspector] public float[] maskAlpha;
    public Material material;

    private void Awake()
    {
        arrayPosition = new Vector4[arrayTransform.Length];
        arraySize = new float[arrayTransform.Length];
        maskAlpha = new float[arrayTransform.Length];
    }

    private void Update()
    {
        for (int i = 0; i < arrayTransform.Length; i++)
        {
            arrayPosition[i]= arrayTransform[i].position;
            arraySize[i]= arrayTransform[i].localScale.x -1;
            maskAlpha[i] = balls[i].maskAlpha;

        }
        
        material.SetVectorArray("_arrayPosition",arrayPosition);
        material.SetFloatArray("_arraySize",arraySize);
        material.SetFloatArray("_maskAlpha",maskAlpha);
    }
}
