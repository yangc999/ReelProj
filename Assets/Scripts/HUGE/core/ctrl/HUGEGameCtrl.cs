using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class HUGEGameCtrl : MonoBehaviour
{
    private HUGEDataMgr dataMgr;
    private HUGESlotsMgr slotsMgr;

    void Awake()
    {
        gameObject.name = "GameCtrl";
    }

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
        slotsMgr = slots.AddComponent<HUGESlotsMgr>();
        slotsMgr.GameCtrl = this;
        slotsMgr.DataMgr = dataMgr;
        var rt = slots.GetComponent<RectTransform>();
        rt.SetParent(gameObject.GetComponent<RectTransform>(), false);
        rt.localPosition = new Vector3(0.0f, 0.0f, 0.0f);
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
