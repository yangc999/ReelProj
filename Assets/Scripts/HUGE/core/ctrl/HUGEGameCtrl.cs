using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUGEGameCtrl : MonoBehaviour
{
    private HUGEDataMgr dataMgr;
    private HUGESlotsMgr slotsMgr;

    // Start is called before the first frame update
    void Start()
    {
        dataMgr = new HUGEDataMgr();
        Build();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void Build()
    {
        var slots = new GameObject();
        slots.transform.parent = gameObject.transform;
        slotsMgr = slots.AddComponent<HUGESlotsMgr>();
        slotsMgr.GameCtrl = this;
        slotsMgr.DataMgr = dataMgr;
    }

    public void DoActionCtrl()
    {

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
