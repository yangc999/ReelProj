using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUGEDriveBearing
{
    public HUGEDriveCtrl Delegate { get; set; }

    private HocViewType ViewType = HocViewType.HocCenter;
    private HocBearingType BearingType = HocBearingType.HocOver;
    private int HocIdx;
    private int HocShowVarGearN;
    private int HocWishGearN;
    private int HocViewShowColMaxGearN;
    private int HocViewMaxLinkGearN;
    private float HocWidth;
    private float HocHeight;
    private int HocFinalGearN;
    private float HocLineWidth;
    private float CenterX;
    private float CenterY;
    private float HocDis;
    private float HocReleaseStopDownTime;
    private float HocStopDownTime;
    private float HocStopDownDis;
    private float HocStopDownDisAdd;
    private float HocMatchDown = 1.0f;
    private float HocReleaseStopUpTime;
    private float HocStopUpTime;
    private float HocStopUpDis;
    private float HocMatchUp = 1.0f;
    private int HocStopTag;
    private HUGEDriveGear HocStopTopGear;
    private HUGEDriveGear HocStopCenterGear;
    private HUGEDriveGear HocStopBottomGear;
    private bool HocMsgBack;
    private bool HocBeforeBearingStop;
    private bool HocUserStop;
    private bool HocAutoStop = true;
    private bool HocTurbo;
    private List<HUGEDriveGear> HocGearList = new List<HUGEDriveGear>();
    public float HocShowVarStopTop;
    public float HocShowVarStopBottom;
    public float HocWishTop;
    public float HocWishBottom;
    public float HocMoveTime;
    public float HocDelayTime;
    public float HocReleaseDelayTime;
    public float HocReleaseMoveTime;

    public HUGEDriveBearing(HUGEDriveCtrl del)
    {
        Delegate = del;
    }

    public void Update(float deltaTime)
    {
        if (BearingType == HocBearingType.HocOver)
        {
            return;
        }
        HocReleaseDelayTime = HocReleaseDelayTime - deltaTime;
        if (HocReleaseDelayTime > 0)
        {
            HocReleaseDelayTime = HocReleaseDelayTime - deltaTime;
            return;
        }
        HocReleaseMoveTime = HocReleaseMoveTime - deltaTime;
        if (HocReleaseMoveTime > 0 && BearingType == HocBearingType.HocSpin)
        {
            Move();
        }
        else if (!HocMsgBack)
        {
            Move();
        }
        else if (!HocBeforeBearingStop)
        {
            Move();
        }
        else
        {
            if (BearingType == HocBearingType.HocSpin)
            {
                WillStop();
            }
            if (BearingType == HocBearingType.HocWill)
            {
                BegStop();
                return;
            }
            if (BearingType == HocBearingType.HocStop)
            {
                DoStop(deltaTime);
            }
        }
    }

    public void InitDearingData(HocViewType viewType, int idx, int showGearN, int wishGearN, int viewShowColMaxGearN, int viewMaxLinkGearN, float width, float height)
    {
        ViewType = viewType;
        HocIdx = idx;
        HocShowVarGearN = showGearN;
        HocWishGearN = wishGearN;
        HocViewShowColMaxGearN = viewShowColMaxGearN;
        HocViewMaxLinkGearN = viewMaxLinkGearN;
        HocWidth = width;
        HocHeight = height;
        HocFinalGearN = HocWishGearN * 2 + HocViewMaxLinkGearN * 2;
        switch (ViewType)
        {
            case HocViewType.HocCenter:
                {
                    HocShowVarStopBottom = (HocViewShowColMaxGearN - HocShowVarGearN) * HocHeight * 0.5f + HocHeight * 0.5f;
                    HocShowVarStopTop = (HocViewShowColMaxGearN - HocShowVarGearN) * HocHeight * 0.5f + HocHeight * 0.5f + (HocShowVarGearN - 1) * HocHeight;
                    HocWishBottom = (HocViewShowColMaxGearN - HocWishGearN) * HocHeight * 0.5f - HocViewMaxLinkGearN * HocHeight;
                    HocWishTop = (HocViewShowColMaxGearN - HocWishGearN) * HocHeight * 0.5f + (HocFinalGearN - HocViewMaxLinkGearN) * HocHeight;
                }
                break;
            case HocViewType.HocTop:
                {
                    HocShowVarStopBottom = HocViewShowColMaxGearN * HocHeight - HocHeight * 0.5f - (HocShowVarGearN-1) * HocHeight;
                    HocShowVarStopTop = HocViewShowColMaxGearN * HocHeight - HocHeight * 0.5f;
                    HocWishBottom = (HocViewShowColMaxGearN + HocViewMaxLinkGearN) * HocHeight - HocFinalGearN * HocHeight;
                    HocWishTop = (HocViewShowColMaxGearN+1) * HocHeight;
                }
                break;
            case HocViewType.HocBottom:
                {
                    HocShowVarStopBottom = HocHeight * 0.5f;
                    HocShowVarStopTop = HocHeight * 0.5f + (HocShowVarGearN-1) * HocHeight;
                    HocWishBottom = HocViewMaxLinkGearN * HocHeight;
                    HocWishTop = (HocFinalGearN - HocViewMaxLinkGearN) * HocHeight;
                }
                break;
            default:
                break;
        }
        HocDelayTime = (HocIdx-1) * HocAmi.HocDelayTime;
        HocMoveTime = HocAmi.HocTime + (HocIdx-1) * HocAmi.HocGapTime;
        HocReleaseDelayTime = HocDelayTime;
        HocReleaseMoveTime = HocMoveTime;
        ResetTime();
        CreateGear();
    }

    public void InitPosAndZorder(int colIdx, float viewLineWidth)
    {
        HocLineWidth = viewLineWidth;
        foreach (var cell in HocGearList)
        {
            cell.HocPosX = cell.HocPosX + (colIdx-1) * HocWidth + (colIdx-1) * viewLineWidth;
            cell.HocZOrder = cell.HocZOrder + (colIdx-1) * (HocWishGearN + 2 * HocViewMaxLinkGearN);
            CenterX = cell.HocPosX;
        }
    }

    public List<HUGEDriveGear> BearingList()
    {
        return HocGearList;
    }

    public Vector2 CenterPos()
    {
        return new Vector2(CenterX, CenterY);
    }

    public void DoAction()
    {
        ResetData();
        if (HocIdx == 1)
        {
            BeforeBearingStopAction(true);
        }
        else
        {
            BeforeBearingStopAction(false);
        }
        BearingType = HocBearingType.HocSpin;
    }

    public void StopAction()
    {
        ResetTime();
        HocMsgBack = true;
        BearingType = HocBearingType.HocSpin;
    }

    public void BeforeBearingStopAction(bool isStop)
    {
        HocBeforeBearingStop = isStop;
    }

    public void QuickStopAction()
    {
        TurboModel(false);
        HocMsgBack = true;
        BeforeBearingStopAction(true);
        HocReleaseMoveTime = 0.0f;
        HocUserStop = true;
    }

    public void TurboModel(bool isTurbo)
    {
        HocTurbo = isTurbo;
        HocDis = HocAmi.HocSpeed;
        if (HocTurbo)
        {
            HocDis = HocAmi.HocSuper;
            if (HocReleaseMoveTime < 0)
            {
                HocReleaseMoveTime = HocAmi.HocSuperAddTime;
            }
            else
            {
                HocReleaseMoveTime = HocReleaseMoveTime + HocAmi.HocSuperAddTime;
            }
        }
    }

    public void RefreshShowGear(int showGear)
    {
        HocShowVarGearN = showGear;
        switch (ViewType)
        {
            case HocViewType.HocCenter:
                {
                    HocShowVarStopBottom = (HocViewShowColMaxGearN - HocShowVarGearN) * HocHeight * 0.5f + HocHeight * 0.5f;
                    HocShowVarStopTop = (HocViewShowColMaxGearN - HocShowVarGearN) * HocHeight * 0.5f + HocHeight * 0.5f + (HocShowVarGearN-1) * HocHeight;
                }
                break;
            case HocViewType.HocTop:
                {
                    HocShowVarStopBottom = HocViewShowColMaxGearN * HocHeight - HocHeight * 0.5f - (HocShowVarGearN-1) * HocHeight;
                    HocShowVarStopTop = HocViewShowColMaxGearN * HocHeight - HocHeight * 0.5f;
                }
                break;
            case HocViewType.HocBottom:
                {
                    HocShowVarStopBottom = HocHeight * 0.5f;
                    HocShowVarStopTop = HocHeight * 0.5f + (HocShowVarGearN-1) * HocHeight;
                }
                break;
            default:
                break;
        }
    }

    public void ResetData()
    {
        ResetTime();
        HocMsgBack = false;
        HocBeforeBearingStop = false;
        HocAutoStop = true;
        HocUserStop = false;
        HocTurbo = false;
        HocStopTag = 0;
        HocDis = 0.0f;
    }

    public void CreateGear()
    {
        var finalGearN = HocFinalGearN;
        for (int i = 0; i < finalGearN; i++)
        {
            var gear = new HUGEDriveGear();
            HocGearList.Add(gear);
        }
    }

    public void ResetTime()
    {
        HocStopDownTime = HocAmi.HocStopDownTime;
        HocStopDownDis = 0;
        HocStopDownDisAdd = 0;
        HocMatchDown = 1;
        HocReleaseStopDownTime = HocStopDownTime;
        HocStopUpTime = HocAmi.HocStopUpTime;
        HocStopUpDis = 0;
        HocMatchUp = 1;
        HocReleaseStopUpTime = HocStopUpTime;
        HocReleaseDelayTime = HocDelayTime;
        HocReleaseMoveTime = HocMoveTime;
    }

    public float GearY(int finalGearN, int row)
    {
        var posY = (finalGearN - row - HocViewMaxLinkGearN) * HocHeight + HocHeight * 0.5f;
        switch (ViewType)
        {
            case HocViewType.HocCenter:
                posY = posY + (HocViewShowColMaxGearN - HocWishGearN) * HocHeight * 0.5f;
                break;
            case HocViewType.HocTop:
                posY = (HocViewShowColMaxGearN + HocViewMaxLinkGearN - row) * HocHeight + HocHeight * 0.5f;
                break;
            case HocViewType.HocBottom:
                break;
            default:
                break;
        }
        return posY;
    }

    public void Move()
    {
        HocDis = HocAmi.HocSpeed;
        if (HocTurbo)
        {
            HocDis = HocAmi.HocSuper;
        }
        MoveList(HocDis);
    }

    public void WillStop()
    {
        BearingType = HocBearingType.HocWill;
        var wishTop = HocWishTop;
        foreach (var cell in HocGearList)
        {
            if (cell.HocPosY > HocShowVarStopTop && cell.HocPosY < wishTop)
            {
                wishTop = cell.HocPosY;
                HocStopTag = cell.HocTag;
                HocStopTopGear = cell;
                HocStopCenterGear = cell;
                HocStopBottomGear = cell;
            }
        }
    }

    public void BegStop()
    {
        var isStop = false;
        var subDis = 0.0f;
        if (HocStopTopGear != null)
        {
            isStop = true;
            subDis = HocStopTopGear.HocPosY - HocShowVarStopTop;
            HocStopDownDis = HocHeight * HocAmi.HocDownParameter + (HocShowVarGearN-1) * HocHeight;
            HocStopUpDis = HocHeight * HocAmi.HocUpParameter;
            BearingType = HocBearingType.HocStop;
            HocStopTopGear = null;
        }
        if (!isStop)
        {
            MoveList(HocDis);
        }
        else
        {
            MoveList(subDis);
            if (Delegate != null)
            {
                var showList = new List<int>();
                for (int i = 0; i < HocShowVarGearN; i++)
                {
                    var tag = (HocStopTag - i + 1 + HocFinalGearN) % HocFinalGearN;
                    if (tag == 0)
                    {
                        tag = HocFinalGearN;
                    }
                    showList.Add(tag);
                }
                showList.Reverse();
                Delegate.StripBegStop(HocIdx, HocStopTag, showList);
            }
        }
    }

    public void DoStop(float time)
    {
        if (BearingType == HocBearingType.HocOver)
        {
            return;
        }
        if (HocReleaseStopDownTime > 0)
        {
            HocReleaseStopDownTime = HocReleaseStopDownTime - time;
            if (HocReleaseStopDownTime <= 0)
            {
                HocReleaseStopDownTime = 0;
            }
            var downTime = HocReleaseStopDownTime / HocStopDownTime;
            var resDown = Mathf.Pow(downTime, 1.5f);
            HocDis = (HocMatchDown - resDown) * HocStopDownDis;
            HocMatchDown = resDown;
            if (HocStopDownDisAdd + HocDis >= HocStopDownDis)
            {
                HocDis = HocStopDownDis - HocStopDownDisAdd;
                HocStopDownTime = 0.0f;
                HocStopDownDisAdd = 0.0f;
            }
            else
            {
                HocStopDownDisAdd = HocStopDownDisAdd + HocDis;
            }
            MoveList(HocDis);
            if (HocStopBottomGear != null)
            {
                if (HocStopBottomGear.HocPosY - HocShowVarStopBottom < 0)
                {
                    HocStopBottomGear = null;
                    if (Delegate != null)
                    {
                        Delegate.StripNearStop(HocIdx);
                    }
                }
            }
            return;
        }
        HocReleaseStopUpTime = HocReleaseStopUpTime - time;
        if (HocReleaseStopUpTime <= 0)
        {
            HocReleaseStopUpTime = 0;
        }
        var upTime = HocReleaseStopUpTime / HocStopUpTime;
        var resUp = 1 - Mathf.Pow(1-upTime, 1.2f);
        HocDis = (HocMatchUp - resUp) * HocStopUpDis;
        HocMatchUp = resUp;
        MoveList(-HocDis);
        if (HocReleaseStopUpTime == 0)
        {
            BearingType = HocBearingType.HocOver;
            if (Delegate != null)
            {
                Delegate.StripEndStop(HocIdx);
            }
        }
    }

    public void MoveList(float dis)
    {
        foreach (var item in HocGearList)
        {
            MoveCell(item, dis);
        }
        if (Delegate != null)
        {
            Delegate.StripMove(HocIdx, HocGearList);
        }
    }

    public void MoveCell(HUGEDriveGear cell, float dis)
    {
        var posY = cell.HocPosY - dis;
        if (posY > HocWishTop)
        {
            posY = posY - HocWishTop + HocWishBottom;
        }
        else if (posY < HocWishBottom)
        {
            posY = posY - HocWishBottom + HocWishTop;
            var tag = cell.HocTag;
            foreach (var item in HocGearList)
            {
                if (item.HocTag == tag)
                {
                    item.HocZOrder = 1;
                }
                else
                {
                    item.HocZOrder = item.HocZOrder + 1;
                }
            }
        }
        cell.HocPosY = posY;
    }
}
