using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Spine.Unity;

[RequireComponent(typeof(RectTransform))]
public class HUGEVtemAmi : MonoBehaviour
{
    public HUGEUnit Unit;
    public int ShowTag;
    public int ColIdx;
    public int RowIdx;
    public bool IsAming;
    private float width;
    private float height;
    private int zOrder;
    private Vector2 size;
    private bool hasAmi;
    private GameObject rootNode;
    private SkeletonGraphic ami;
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
        gameObject.name = "VtemAmi";
        Unit = new HUGEUnit();
        Unit.Set(unit);
        width = nWidth;
        height = nHeight;
        size = new Vector2(width, height);
        var rt = gameObject.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.5f, 0.5f);
        rt.sizeDelta = size;
        hasAmi = true;
        if (Unit.Ami.Count == 0)
        {
            hasAmi = false;
        }
        LoadAmi();
        ClearAmiState();
    }

    public void PlayAnimation(bool isForever, string sAmi)
    {
        if (IsAming)
        {
            return;
        }
        IsAming = true;
        StopAmi();
        if (ami)
        {
            foreach (var item in Unit.Ami)
            {
                if (item == sAmi)
                {
                    ami.AnimationState.SetAnimation(0, item, isForever);
                    break;
                }
            }
        }
    }

    public void SetRC(int col, int row)
    {
        ColIdx = col;
        RowIdx = row;
    }

    public void ClearAmiState()
    {
        ColIdx = -1;
        RowIdx = -1;
        ShowTag = -1;
        IsAming = false;
    }

    public int GetId()
    {
        return Unit.Id;
    }

    public void SetZOrder(int zord)
    {
        var localZorder = IconZOrder(Unit.Type) + zOrder + zord;
    }

    public void Show(bool visible)
    {
        if (rootNode)
        {
            rootNode.SetActive(visible);
        }
    }

    public void StopAmi()
    {
        if (ami)
        {
            ami.AnimationState.ClearTracks();
        }
    }

    public void LoadAmi()
    {
        if (!rootNode)
        {
            rootNode = new GameObject();
            var rootRt = rootNode.AddComponent<RectTransform>();
            rootRt.anchorMin = new Vector2(0.5f, 0.5f);
            rootRt.anchorMax = new Vector2(0.5f, 0.5f);
            rootRt.pivot = new Vector2(0.5f, 0.5f);
            rootRt.SetParent(gameObject.GetComponent<RectTransform>(), false);
            rootRt.anchoredPosition = new Vector3(0.0f, 0.0f, 0.0f);
        }
        if (hasAmi)
        {
            var path = AmiPath();
            var amiObj = new GameObject();
            ami = amiObj.AddComponent<SkeletonGraphic>();
            if (ami)
            {
                var rt = ami.GetComponent<RectTransform>();
                rt.anchorMin = new Vector2(0.5f, 0.5f);
                rt.anchorMax = new Vector2(0.5f, 0.5f);
                rt.pivot = new Vector2(0.5f, 0.5f);
                rt.SetParent(rootNode.GetComponent<RectTransform>(), false);
            }
        }
        else
        {
            var path = ImageName();
            if (!ami)
            {

            }
        }
    }

    public string AmiPath()
    {
        return "Spine/" + "slots_" + Unit.Id;
    }

    public string ImageName()
    {
        return "Pic/" + "slots_" + Unit.Id;
    }

    public Vector3 AmiPos()
    {
        return new Vector3(0.0f, 0.0f, 0.0f);
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
