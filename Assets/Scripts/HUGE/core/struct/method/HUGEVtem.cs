using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform), typeof(Image))]
public class HUGEVtem : MonoBehaviour
{
    public HUGEUnit Unit;
    public int TagIdx;
    private float width;
    private float height;
    private int defaultIdx;
    private int zOrder;
    private Vector2 size;
    private Image icon;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Init(HUGEUnit unit, float nWidth, float nHeight)
    {
        Unit = new HUGEUnit();
        Unit.Set(unit);
        width = nWidth;
        height = nHeight;
        TagIdx = 0;
        defaultIdx = 0;
        zOrder = 0;
        size = new Vector2(width, height);
        LoadItemIcon();
        SetZOrder(0);
    }

    public void RefreshItemIcon(HUGEUnit unit)
    {
        if (unit == null || Unit.Id == unit.Id)
        {
            return;
        }
        Unit.Set(unit);
        LoadItemIcon();
    }

    public void SetZOrder(int zord)
    {
        var localZorder = IconZOrder(Unit.Type) + zOrder + zord;

    }

    public void Show(bool visible)
    {
        if (!icon)
        {
            var imageObj = new GameObject();
            icon = imageObj.AddComponent<Image>();
        }
        var name = IconName();
        var spr = Resources.Load<Sprite>(name);
        if (icon && spr)
        {
            icon.sprite = spr;
        }
    }

    public void LoadItemIcon()
    {
        var image = gameObject.GetComponent<Image>();
    }

    public string IconName()
    {
        return "slots_" + Unit.Id + ".png";
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
