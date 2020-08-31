using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Spine.Unity;

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
        size = new Vector2(width, height);
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
        }
        if (hasAmi)
        {
            var path = AmiPath();
            var amiObj = new GameObject();
            ami = amiObj.AddComponent<SkeletonGraphic>();
            if (ami)
            {
                ami.
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
        return;
    }

    public string ImageName()
    {
        return;
    }

    public Vector2 AmiPos()
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
