using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUGEMachineLayerMgr : MonoBehaviour
{
    public HUGEDataMgr DataMgr { get; set; }
    public HUGESlotsMgr SlotsCtrl { get; set; }

    private HUGEDriveCtrl driveCtrl;
    private HUGEReelMgr reelMgr;
    private HUGEReelAmiMgr reelAmiMgr;

    // Start is called before the first frame update
    void Start()
    {
        Init();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void Init()
    {
        var driveCtrlObj = new GameObject();
        driveCtrlObj.transform.parent = gameObject.transform;
        driveCtrl = driveCtrlObj.AddComponent<HUGEDriveCtrl>();
        driveCtrl.Delegate = this;
        driveCtrl.InitData();

        var reelMgrObj = new GameObject();
        reelMgrObj.transform.parent = gameObject.transform;
        reelMgr = reelMgrObj.AddComponent<HUGEReelMgr>();
        reelMgr.CreateSlotsLayer();

        var reelAmiMgrObj = new GameObject();
        reelAmiMgrObj.transform.parent = gameObject.transform;
        reelAmiMgr = reelAmiMgrObj.AddComponent<HUGEReelAmiMgr>();
        reelAmiMgr.CreateSlotsAmiLayer();

        RefreshWishModel();
    }
    
    public void DoAction()
    {
        driveCtrl.DoAction();
        reelAmiMgr.ClearAmiCacheState();
    }

    public void StopAction()
    {
        driveCtrl.StopAction();
    }

    public void QuickStopAction()
    {
        driveCtrl.QuickStopAction();
    }

    public void TurboModel(int idx, bool isTurbo)
    {
        driveCtrl.TurboModel(idx, isTurbo);
    }

    // delegate
    public void StripMove(int idx, List<HUGEDriveGear> cellList)
    {

    }

    public void StripBegStop(int idx, int stopTag, List<int> showTagLis)
    {

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
    }

    public void RefreshNormalModel()
    {
        reelMgr.RefreshNormalModel();
        reelAmiMgr.RefreshNormalModel();
        driveCtrl.RefreshNormalModel();
    }

    public void RefreshWishModel()
    {
        reelMgr.RefreshWishModel();
        reelAmiMgr.RefreshWishModel();
        driveCtrl.RefreshWishModel();
    }
}
