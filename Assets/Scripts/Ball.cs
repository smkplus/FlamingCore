using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ball : MonoBehaviour
{
    public float maskAlpha;
    



    private void Update()
    {
        maskAlpha = Mathf.Clamp(maskAlpha >= 0 ? maskAlpha -= Time.deltaTime : maskAlpha = 0,0,1);
        
    }
}
