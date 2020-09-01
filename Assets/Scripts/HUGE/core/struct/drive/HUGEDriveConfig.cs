using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class HocAmi
{
    public const float HocSpeed = 30.0f;
    public const float HocSuper = 50.0f;
    public const float HocTime = 0.12f;
    public const float HocStopDownTime = 0.2f;
    public const float HocStopUpTime = 0.2f;
    public const float HocGapTime = 0.2f;
    public const float HocDelayTime = 0.0f;
    public const float HocDownParameter = 0.2f;
    public const float HocUpParameter = 0.2f;
    public const float HocSuperAddTime = 2.0f;
    public const float HocQuickStopTimeParameter = 2.0f;
}

public enum HocViewType
{
    HocCenter = 0,
    HocTop,
    HocBottom, 
}

public enum HocBearingType
{
    HocSpin = 0,
    HocWill, 
    HocStop,
    HocOver, 
}

public class HUGEDriveConfig
{

}
