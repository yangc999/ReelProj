﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUGEDriveGear : MonoBehaviour
{
    public int HocTag;
    public float HocWidth;
    public float HocHeight;
    public int HocMaxLink;
    public float HocPosX;
    public float HocPosY;
    public int HocZOrder;
    public int HocRow;
    public int HocCol;

    // Start is called before the first frame update
    void Start()
    {
        Init();
    }

    // Update is called once per frame
    void Update()
    {

    }

    private void Init()
    {
        HocTag = 0;
        HocWidth = 0.0f;
        HocHeight = 0.0f;
        HocMaxLink = 1;
        HocPosX = 0.0f;
        HocPosY = 0.0f;
        HocZOrder = 0;
        HocRow = 0;
        HocCol = 0;
    }
}