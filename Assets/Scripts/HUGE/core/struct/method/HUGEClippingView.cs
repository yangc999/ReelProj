using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class HUGEClippingView : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Init(ReelConfig cfg, float addWidth = 0.0f, float addHeight = 0.0f)
    {
        var rt = gameObject.GetComponent<RectTransform>();
        var size = new Vector2(cfg.RcWidth, cfg.RcHeight);
        rt.sizeDelta = size;
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.5f, 0.5f);
        ChangeModel(cfg, addWidth, addHeight);
    }

    public void ChangeModel(ReelConfig cfg, float addWidth, float addHeight)
    {

    }
}
