using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class HUGEMachineLayerMgr : MonoBehaviour
{
    public HUGEDataMgr DataMgr { get; set; }
    public HUGESlotsMgr SlotsCtrl { get; set; }
    public HUGEDriveCtrl DriveCtrl { get; set; }
    private HUGEReelMgr reelMgr;
    private HUGEReelAmiMgr reelAmiMgr;
    private int touchIdx;

    void Awake()
    {
        var rt = gameObject.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.0f, 0.0f);
    }

    // Start is called before the first frame update
    void Start()
    {
        Init();
    }

    // Update is called once per frame
    void Update()
    {
        if (DriveCtrl != null)
        {
            DriveCtrl.Update(Time.deltaTime);
        }
    }

    private void Init()
    {
        DriveCtrl = new HUGEDriveCtrl(this);
        DriveCtrl.InitData(DataMgr.Data);

        var reelMgrObj = new GameObject();
        reelMgr = reelMgrObj.AddComponent<HUGEReelMgr>();
        reelMgr.MachineMgr = this;
        var reelMgrObjRt = reelMgrObj.GetComponent<RectTransform>();
        reelMgrObjRt.SetParent(gameObject.GetComponent<RectTransform>(), false);
        reelMgr.CreateSlotsLayer();

        var reelAmiMgrObj = new GameObject();
        reelAmiMgr = reelAmiMgrObj.AddComponent<HUGEReelAmiMgr>();
        reelAmiMgr.MachineMgr = this;
        var reelAmiMgrObjRt = reelAmiMgrObj.GetComponent<RectTransform>();
        reelAmiMgrObjRt.SetParent(gameObject.GetComponent<RectTransform>(), false);
        reelAmiMgr.CreateSlotsAmiLayer();

        RefreshWishModel();
        touchIdx = 1;
    }
    
    public void DoAction()
    {
        DriveCtrl.DoAction();
        reelAmiMgr.ClearAmiCacheState();
    }

    public void StopAction()
    {
        DriveCtrl.StopAction();
    }

    public void QuickStopAction()
    {
        DriveCtrl.QuickStopAction();
    }

    public void TurboModel(int idx, bool isTurbo)
    {
        DriveCtrl.TurboModel(idx, isTurbo);
    }

    // delegate
    public void StripMove(int idx, List<HUGEDriveGear> cellList)
    {
        reelMgr.StripMove(idx, cellList);
        reelAmiMgr.StripMove(idx, cellList);
    }

    public void StripBegStop(int idx, int stopTag, List<int> showTagList)
    {
        reelMgr.StripBegStop(idx, stopTag, showTagList);
        reelAmiMgr.StripBegStop(idx, stopTag, showTagList, DataMgr.Data.TrueStrips);
    }

    public void StripNearStop(int idx)
    {
        reelMgr.StripNearStop(idx);
        reelAmiMgr.StripNearStop(idx);
    }

    public void StripEndStop(int idx)
    {
        reelMgr.StripEndStop(idx);
        reelAmiMgr.StripEndStop(idx);
        if (idx == DataMgr.Data.Col)
        {
            SlotsCtrl.AllStripEndStop();
        }
    }

    public void RefreshNormalModel()
    {
        reelMgr.RefreshNormalModel();
        reelAmiMgr.RefreshNormalModel();
        DriveCtrl.RefreshNormalModel(DataMgr.Data.RcList);
    }

    public void RefreshWishModel()
    {
        reelMgr.RefreshWishModel();
        reelAmiMgr.RefreshWishModel();
        DriveCtrl.RefreshWishModel(DataMgr.Data.RcListWish);
    }
}
