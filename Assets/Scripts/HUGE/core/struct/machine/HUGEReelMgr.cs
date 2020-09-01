using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class HUGEReelMgr : MonoBehaviour
{
    public HUGEMachineLayerMgr MachineMgr { get; set; }

    private List<List<HUGEVtem>> reelArr = new List<List<HUGEVtem>>();
    private HUGEClippingView slotsLayer;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void InitReel()
    {
        for (int i = 0; i < MachineMgr.DataMgr.Data.RcList.Count; i++)
        {
            var gearList = MachineMgr.DriveCtrl.DearingInfoListByIdx(i);
            var reelItemArr = new List<HUGEVtem>();
            for (int j = 0; j < gearList.Count; j++)
            {
                var gear = gearList[j];
                var slotsId = MachineMgr.DataMgr.DefaultSlotsByRC(i, j);
                var unit = MachineMgr.DataMgr.ElementById(slotsId);
                if (unit != null)
                {
                    var itemObj = new GameObject();
                    var item = itemObj.AddComponent<HUGEVtem>();
                    item.Init(unit, MachineMgr.DataMgr.Data.CellWidth, MachineMgr.DataMgr.Data.CellHeight);
                    item.TagIdx = gear.HocTag;
                    item.SetZOrder(gear.HocZOrder);
                    var rt = itemObj.GetComponent<RectTransform>();
                    rt.SetParent(slotsLayer.gameObject.GetComponent<RectTransform>(), false);
                    reelItemArr.Add(item);
                }
            }
            reelArr.Add(reelItemArr);
        }
    }

    public void CreateSlotsLayer()
    {
        if (!slotsLayer)
        {
            var slotsLayerObj = new GameObject();
            slotsLayer = slotsLayerObj.AddComponent<HUGEClippingView>();
            var rt = slotsLayerObj.GetComponent<RectTransform>();
            rt.SetParent(gameObject.GetComponent<RectTransform>(), false);
        }
        InitReel();
    }

    public void StripMove(int colIdx, List<HUGEDriveGear> cellList)
    {
        var reelItemArr = reelArr[colIdx];
        foreach (var item in reelItemArr)
        {
            foreach (var cell in cellList)
            {
                if (item.TagIdx == cell.HocTag)
                {
                    item.SetZOrder(cell.HocTag);

                    break;
                }
            }
        }
    }

    public void StripBegStop(int colIdx, int stopTag, List<int> showTagList)
    {
        var reelColList = reelArr[colIdx];
        var trueReelList = MachineMgr.DataMgr.Data.TrueStrips[colIdx];
        for (int i = 0; i < trueReelList.Count; i++)
        {
            var trueSlotsId = trueReelList[i];
            var showTag = showTagList[i];
            foreach (var vtem in reelColList)
            {
                if (vtem.TagIdx == showTag)
                {
                    var unit = MachineMgr.DataMgr.ElementById(trueSlotsId);
                    vtem.RefreshItemIcon(unit);
                    break;
                }
            }
        }
    }

    public void StripNearStop(int colIdx)
    {

    }

    public void StripEndStop(int colIdx)
    {

    }

    public void RefreshNormalModel()
    {
        slotsLayer.ChangeModel(MachineMgr.DataMgr.ReelClippingCfg(), 0.0f, 0.0f);
    }

    public void RefreshWishModel()
    {
        slotsLayer.ChangeModel(MachineMgr.DataMgr.ReelClippingWishCfg(), 0.0f, 0.0f);
    }
}
