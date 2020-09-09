using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class HUGEReelMgr : MonoBehaviour
{
    public HUGEMachineLayerMgr MachineMgr { get; set; }

    private List<List<HUGEVtem>> reelArr = new List<List<HUGEVtem>>();
    private HUGEClippingView slotsLayer;

    void Awake()
    {
        var rt = gameObject.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.0f, 0.0f);
        gameObject.name = "ReelMgr";
    }

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
                    var rt = itemObj.GetComponent<RectTransform>();
                    rt.SetParent(slotsLayer.gameObject.GetComponent<RectTransform>(), false);
                    rt.anchoredPosition = new Vector3(gear.HocPosX, gear.HocPosY, 0.0f);
                    item.TagIdx = gear.HocTag;
                    item.SetZOrder(gear.HocZOrder);
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
            slotsLayer.name = "SlotsLayer";
            var rt = slotsLayerObj.GetComponent<RectTransform>();
            rt.SetParent(gameObject.GetComponent<RectTransform>(), false);
            Canvas canvas = FindObjectOfType<Canvas>();
            float h = canvas.GetComponent<RectTransform>().rect.height;
            float w = canvas.GetComponent<RectTransform>().rect.width;
            rt.anchoredPosition = new Vector3(w * 0.5f, h * 0.5f, 0.0f);
            slotsLayer.Init(MachineMgr.DataMgr.ReelClippingCfg());
        }
        InitReel();
    }

    public void StripMove(int colIdx, List<HUGEDriveGear> cellList)
    {
        var reelItemArr = reelArr[colIdx-1];
        foreach (var item in reelItemArr)
        {
            foreach (var cell in cellList)
            {
                if (item.TagIdx == cell.HocTag)
                {
                    item.SetZOrder(cell.HocTag);
                    var rt = item.gameObject.GetComponent<RectTransform>();
                    rt.anchoredPosition = new Vector3(cell.HocPosX, cell.HocPosY, 0.0f);
                    break;
                }
            }
        }
    }

    public void StripBegStop(int colIdx, int stopTag, List<int> showTagList)
    {
        var reelColList = reelArr[colIdx-1];
        var trueReelList = MachineMgr.DataMgr.Data.TrueStrips[colIdx-1];
        for (int i = 0; i < trueReelList.Count; i++)
        {
            if (i < showTagList.Count)
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
