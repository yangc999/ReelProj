using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUGEDriveCtrl : MonoBehaviour
{
    public HUGEMachineLayerMgr Delegate { get; set; }

    private List<HUGEDriveBearing> bearingList = new List<HUGEDriveBearing>();

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void InitData()
    {
        for (int i = 0; i < int.MaxValue; i++)
        {
            var bearingObj = new GameObject();
            bearingObj.transform.parent = gameObject.transform;
            var bearing = bearingObj.AddComponent<HUGEDriveBearing>();
            bearing.Delegate = this;
            bearing.InitDearingData();
            bearing.InitPosAndZorder();
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

    public void DearingInfoListByIdx(int idx)
    {
        if (bearingList.Count != 0)
        {
            var bearing = bearingList[idx];
            bearing.BearingList();
        }
    }

    public void DearingCenterPosByIdx(int idx)
    {
        if (bearingList.Count != 0)
        {
            var bearing = bearingList[idx];
            bearing.CenterPos();
        }
    }

    public void RefreshNormalModel()
    {
        if (bearingList.Count != 0)
        {
            for (int i = 0; i < bearingList.Count; i++)
            {
                var bearing = bearingList[i];
                bearing.RefreshShowGear();
            }
        }
    }

    public void RefreshWishModel()
    {
        if (bearingList.Count != 0)
        {
            for (int i = 0; i < bearingList.Count; i++)
            {
                var bearing = bearingList[i];
                bearing.RefreshShowGear();
            }
        }
    }
}
