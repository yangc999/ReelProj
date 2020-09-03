﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ElementUnit
{
    public int id;
    public int num;
    public SlotsElementType type;
    public List<string> ami;
}

[CreateAssetMenu(fileName = "SlotsConfig", menuName = "Slots Data", order = 51)]
[System.Serializable]
public class HUGESlotsData : ScriptableObject
{
    public int slotsId;
    public string slotsName;
    public HocViewType viewAlignmentType;
    public List<int> rcList;
    public List<int> rcWishList;
    public float viewWidth;
    public float viewHeight;
    public float viewLineWidth;
    public float viewAnimClipLeftAndRight;
    public float viewAnimClipTopAndBottom;
    public List<List<int>> initArr;
    public List<List<int>> rollerArr;
    public List<ElementUnit> elementArr;
}