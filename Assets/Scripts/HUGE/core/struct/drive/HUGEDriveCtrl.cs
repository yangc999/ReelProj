using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUGEDriveCtrl
{
    public HUGEMachineLayerMgr Delegate { get; set; }

    private List<HUGEDriveBearing> bearingList = new List<HUGEDriveBearing>();

    public HUGEDriveCtrl(HUGEMachineLayerMgr del)
    {
        Delegate = del;
    }

    public void Update(float deltaTime)
    {
        if (bearingList.Count != 0)
        {
            foreach (var bearing in bearingList)
            {
                bearing.Update(deltaTime);
            }
        }
    }

    public void InitData(ConfigData slotsData)
    {
        for (int i = 0; i < slotsData.RcList.Count; i++)
        {
            var j = slotsData.RcList[i];
            var wish = slotsData.RcListWish[i];
            var bearing = new HUGEDriveBearing(this);
            bearing.InitDearingData(slotsData.ViewType, i+1, j, wish, slotsData.Row, slotsData.CellMaxNum, slotsData.CellWidth, slotsData.CellHeight);
            bearing.InitPosAndZorder(i+1, slotsData.LineWidth);
            bearingList.Add(bearing);
        }
    }

    public void StripMove(int colIdx, List<HUGEDriveGear> cellList)
    {
        Delegate.StripMove(colIdx, cellList);
    }

    public void StripBegStop(int colIdx, int stopTag, List<int> showTagList)
    {
        Delegate.StripBegStop(colIdx, stopTag, showTagList);
    }

    public void StripNextStop(int colIdx)
    {
        var nextIdx = colIdx + 1;
        if (nextIdx <= 5)
        {
            var bearing = bearingList[nextIdx];
            bearing.BeforeBearingStopAction(true);
        }
    }

    public void StripNearStop(int colIdx)
    {
        Delegate.StripNearStop(colIdx);
    }

    public void StripEndStop(int colIdx)
    {
        Delegate.StripEndStop(colIdx);
    }

    public void DoAction()
    {
        if (bearingList.Count != 0)
        {
            foreach (var bearing in bearingList)
            {
                bearing.DoAction();
            }
        }
    }

    public void StopAction()
    {
        if (bearingList.Count != 0)
        {
            foreach (var bearing in bearingList)
            {
                bearing.StopAction();
            }
        }
    }

    public void BeforeReelStopAction(int idx, bool isStop)
    {
        if (bearingList.Count != 0)
        {
            var bearing = bearingList[idx];
            bearing.BeforeBearingStopAction(isStop);
        }
    }

    public void QuickStopAction()
    {
        if (bearingList.Count != 0)
        {
            foreach (var bearing in bearingList)
            {
                bearing.QuickStopAction();
            }
        }
    }

    public void TurboModel(int idx, bool isTurbo)
    {
        if (bearingList.Count != 0)
        {
            var bearing = bearingList[idx];
            bearing.TurboModel(isTurbo);
        }
    }

    public List<HUGEDriveGear> DearingInfoListByIdx(int idx)
    {
        if (bearingList.Count != 0)
        {
            var bearing = bearingList[idx];
            return bearing.BearingList();
        }
        return null;
    }

    public void DearingCenterPosByIdx(int idx)
    {
        if (bearingList.Count != 0)
        {
            var bearing = bearingList[idx];
            bearing.CenterPos();
        }
    }

    public void RefreshNormalModel(List<int> normalList)
    {
        if (bearingList.Count != 0)
        {
            for (int i = 0; i < bearingList.Count; i++)
            {
                var bearing = bearingList[i];
                bearing.RefreshShowGear(normalList[i]);
            }
        }
    }

    public void RefreshWishModel(List<int> wishList)
    {
        if (bearingList.Count != 0)
        {
            for (int i = 0; i < bearingList.Count; i++)
            {
                var bearing = bearingList[i];
                bearing.RefreshShowGear(wishList[i]);
            }
        }
    }
}
