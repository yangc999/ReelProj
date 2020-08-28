using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform), typeof(Image))]
public class HUGEVtem : MonoBehaviour
{
    public HUGEUnit Unit;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void RefreshItemIcon(HUGEUnit unit)
    {
        LoadItemIcon();
    }

    public void SetTagIdx()
    {

    }

    public void SetZOrder(int zorder)
    {

    }

    public void Show(bool visible)
    {

    }

    public void LoadItemIcon()
    {
        var image = gameObject.GetComponent<Image>();
    }

    public void IconName()
    {

    }

    public Vector2 IconPos()
    {
        return new Vector2(0.0f, 0.0f);
    }

    public SlotsElementZOrder IconZOrder(SlotsElementType ntype, int unitNum = 0)
    {
        switch (ntype)
        {
            case SlotsElementType.Normal:
                return SlotsElementZOrder.Normal;
            case SlotsElementType.Important:
                return unitNum >= 2 ? SlotsElementZOrder.Special : SlotsElementZOrder.Normal;
            case SlotsElementType.Wild:
                return SlotsElementZOrder.Wild;
            case SlotsElementType.Bonus:
                return SlotsElementZOrder.Bonus;
            case SlotsElementType.Scatter:
            case SlotsElementType.ScatterX:
            case SlotsElementType.ScatterXXX:
            case SlotsElementType.ScatterXXXX:
                return SlotsElementZOrder.Scatter;
            default:
                return SlotsElementZOrder.Null;
        }
    }
}
