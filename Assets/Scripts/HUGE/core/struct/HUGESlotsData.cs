using System.Collections;
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

[System.Serializable]
public struct IntList
{
    public List<int> arr;
}

[CreateAssetMenu(fileName = "SlotsConfig", menuName = "Slots Data/Config", order = 51)]
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
    public List<IntList> initArr;
    public List<IntList> rollerArr;
    public List<ElementUnit> elementArr;
}
