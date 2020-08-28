using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUGESlotsMgr : MonoBehaviour
{
    public HUGEGameCtrl GameCtrl { get; set; }
    public HUGEDataMgr DataMgr { get; set; }

    private HUGEMachineLayerMgr machineLayerMgr;
    private HUGEBottomBarLayerMgr bottomBarLayerMgr;
    private SlotsCtrlType slotsCtrlType;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    // btn spin
    public void DelegateBtnSpinAction()
    {

    }

    public void AllStripEndStop()
    {
        bottomBarLayerMgr.RefreshSpinBtnType();
    }

    // build
    private void Build()
    {
        var machineLayer = new GameObject();
        machineLayer.transform.parent = gameObject.transform;
        machineLayerMgr = machineLayer.AddComponent<HUGEMachineLayerMgr>();
        machineLayerMgr.SlotsCtrl = this;

        var bottomBarLayer = new GameObject();
        bottomBarLayer.transform.parent = gameObject.transform;
        bottomBarLayerMgr = bottomBarLayer.AddComponent<HUGEBottomBarLayerMgr>();
        bottomBarLayerMgr.Delegate = this;
    }


    // ctrl
    public void DoActionCtrl(SlotsCtrlType ctrlType)
    {
        if (slotsCtrlType == ctrlType)
            return;
        slotsCtrlType = ctrlType;
        switch (slotsCtrlType)
        {
            case SlotsCtrlType.SlotsStart:
                DoCtrlStart();
                break;
            case SlotsCtrlType.SlotsResult:
                DoCtrlResult();
                break;
            case SlotsCtrlType.SlotsBalance:
                DoCtrlBalance();
                break;
            case SlotsCtrlType.SlotsEnd:
                DoCtrlEnd();
                break;
            case SlotsCtrlType.SlotsOver:
                DoCtrlOver();
                break;
            default:
                break;
        }
    }

    public void DoCtrlStart()
    {

    }

    public void DoCtrlResult()
    {

    }

    public void DoCtrlBalance()
    {

    }

    public void DoCtrlEnd()
    {

    }

    public void DoCtrlOver()
    {

    }
}
