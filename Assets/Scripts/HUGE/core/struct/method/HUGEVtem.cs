using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform))]
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
        gameObject.name = "Vtem";
        Unit = new HUGEUnit();
        Unit.Set(unit);
        width = nWidth;
        height = nHeight;
        TagIdx = 0;
        defaultIdx = 0;
        zOrder = 0;
        size = new Vector2(width, height);
        var rt = gameObject.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.5f, 0.5f);
        rt.sizeDelta = size;
        LoadItemIcon();
        SetZOrder(0);
        Debug.Log("Vtem Init");
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
        if (icon)
        {
            icon.gameObject.SetActive(visible);
        }
    }

    public void LoadItemIcon()
    {
        Debug.Log(string.Format("Name:{0}", gameObject.name));
        var name = IconName();
        Debug.Log(string.Format("IconName:{0}", name));
        if (!icon)
        {
            var imageObj = new GameObject();
            imageObj.name = "icon";
            var imageObjRt = imageObj.AddComponent<RectTransform>();
            imageObjRt.anchorMin = new Vector2(0.5f, 0.5f);
            imageObjRt.anchorMax = new Vector2(0.5f, 0.5f);
            imageObjRt.pivot = new Vector2(0.5f, 0.5f);
            imageObjRt.SetParent(gameObject.GetComponent<RectTransform>(), false);
            icon = imageObj.AddComponent<Image>();
        }
        var rt = icon.gameObject.GetComponent<RectTransform>();
        rt.localPosition = IconPos();
        var spr = Resources.Load<Sprite>(name);
        Debug.Log(string.Format("Sprite:{0}", spr));
        if (icon && spr)
        {
            icon.sprite = spr;
            icon.SetNativeSize();
            Debug.Log(string.Format("Position:{0}, Parent:{1}", icon.gameObject.GetComponent<RectTransform>().position, icon.gameObject.GetComponent<RectTransform>().parent.gameObject.name));
        }
    }

    public string IconName()
    {
        return "Pic/" + "slots_" + Unit.Id;
    }

    public Vector3 IconPos()
    {
        return new Vector3(width*0.5f, height*0.5f, 0.0f);
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
