using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class WallMask : MonoBehaviour
{
    private Material _material;
    public WorldMask worldMask;
    

    private void Start()
    {
        _material = GetComponent<MeshRenderer>().sharedMaterial;
    }

    private void Update()
    {
        _material.SetVectorArray("_arrayPosition",worldMask.arrayPosition);
        _material.SetFloatArray("_arraySize",worldMask.arraySize);
        _material.SetFloatArray("_maskAlpha",worldMask.maskAlpha);
    }
}
