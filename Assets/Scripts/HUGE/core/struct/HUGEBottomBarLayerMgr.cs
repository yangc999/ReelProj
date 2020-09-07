using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class HUGEBottomBarLayerMgr : MonoBehaviour
{
    public HUGESlotsMgr Delegate { get; set; }

    void Awake()
    {
        var rt = gameObject.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.0f, 0.0f);
        gameObject.name = "BottomBarLayerMgr";
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void RefreshSpinBtnType(SpinBtnType stype, bool enable)
    {

    }
}
