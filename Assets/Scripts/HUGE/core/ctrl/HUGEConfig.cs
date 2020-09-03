using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum SlotsCtrlType : int
{
    SlotsStart = 0, 
    SlotsResult, 
    SlotsBalance, 
    SlotsEnd, 
    SlotsOver, 
}

public enum ViewZOrder : int
{
    BgOrder = 1000, 
    ReelOrder = 2000, 
    TitleOrder = 3000, 
    AnimOrder = 4000, 
    TipsOrder = 5000, 
    ExtOrder = 6000, 
    ActivityOrder = 7000, 
    ResultOrder = 8000, 
}

public enum SlotsWinType : int
{
    Normal = 0, 
    BigWin = 1, 
    MegaWin = 2, 
    HugeWin = 3, 
    EpicWin = 4, 
}

public enum SlotsFeatureState : int
{
    FWait = 0,
    FProc = 1,
    FFinish = 2, 
}

public enum SlotsRCType : int
{
    Center = 0,
    Top = 1,
    Bottom = 2, 
}

public enum SlotsElementType : int
{
    Normal = 0, 
    Important = 1, 
    Wild = 2, 
    Scatter = 3, 
    Bonus = 4, 
    ScatterX = 5, 
    ScatterXX = 6, 
    ScatterXXX = 7, 
    ScatterXXXX = 8, 
}

public enum SlotsElementZOrder : int
{
    Null = 0, 
    Normal = 1, 
    Special = 2, 
    Wild = 51, 
    Scatter = 61, 
    Bonus = 61, 
    Max = 71, 
}

public enum SpinBtnType : int
{
    BtnNull = -1, 
    BtnSpin = 0, 
    BtnStop = 1, 
    BtnFreeSpin = 2, 
    BtnAuto = 3, 
}

public class HUGEConfig : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
