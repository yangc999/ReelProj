using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class HUGESlotsMgr : MonoBehaviour
{
    public HUGEGameCtrl GameCtrl { get; set; }
    public HUGEDataMgr DataMgr { get; set; }

    private HUGEMachineLayerMgr machineLayerMgr;
    private HUGEBottomBarLayerMgr bottomBarLayerMgr;
    private SlotsCtrlType slotsCtrlType = SlotsCtrlType.SlotsOver;

    void Awake()
    {
        var rt = gameObject.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.0f, 0.0f);
        gameObject.name = "SlotsMgr";
    }

    // Start is called before the first frame update
    void Start()
    {
        Build();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    // btn spin
    public void DelegateBtnSpinAction(SpinBtnType stype)
    {
        switch (stype)
        {
            case SpinBtnType.BtnSpin:
                {
                    machineLayerMgr.DoAction();
                    bottomBarLayerMgr.RefreshSpinBtnType(SpinBtnType.BtnStop, true);
                }
                break;
            case SpinBtnType.BtnStop:
                {
                    machineLayerMgr.QuickStopAction();
                    bottomBarLayerMgr.RefreshSpinBtnType(SpinBtnType.BtnSpin, false);
                }
                break;
            case SpinBtnType.BtnFreeSpin:
            case SpinBtnType.BtnAuto:
                break;
            default:
                break;
        }
    }

    public void AllStripEndStop()
    {
        bottomBarLayerMgr.RefreshSpinBtnType(SpinBtnType.BtnSpin, true);
    }

    // build
    private void Build()
    {
        var machineLayer = new GameObject();
        machineLayerMgr = machineLayer.AddComponent<HUGEMachineLayerMgr>();
        machineLayerMgr.SlotsCtrl = this;
        machineLayerMgr.DataMgr = DataMgr;
        var machineLayerRt = machineLayer.GetComponent<RectTransform>();
        machineLayerRt.SetParent(gameObject.GetComponent<RectTransform>(), false);
        machineLayerRt.localPosition = new Vector3(0.0f, 0.0f, 0.0f);

        var bottomBarLayer = new GameObject();
        bottomBarLayerMgr = bottomBarLayer.AddComponent<HUGEBottomBarLayerMgr>();
        bottomBarLayerMgr.Delegate = this;
        var bottomBarLayerRt = bottomBarLayer.GetComponent<RectTransform>();
        bottomBarLayerRt.SetParent(gameObject.GetComponent<RectTransform>(), false);
        bottomBarLayerRt.localPosition = new Vector3(0.0f, 0.0f, 0.0f);
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
