using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConfigData
{
    public int Id;
    public string Name;
    public HocViewType ViewType;
    public int Row;
    public int Col;
    public List<int> RcList;
    public List<int> RcListWish;
    public List<HUGEUnit> ElementUnitList;
    public List<List<int>> ElementInitList;
    public List<List<int>> RollerList;
    public List<List<int>> TrueStrips;
    public float RowWidth;
    public float ColHeight;
    public float LineWidth;
    public float CellWidth;
    public float CellHeight;
    public int CellMaxNum;
    public float ViewAnimClipLeftAndRight;
    public float ViewAnimClipTopAndBottom;
}

public class ReelConfig
{
    public List<int> RcList;
    public HocViewType RcType;
    public float RcLineWidth;
    public float RcItemWidth;
    public float RcItemHeight;
    public float RcWidth;
    public float RcHeight;
}

public class HUGEDataMgr : MonoBehaviour
{
    public ConfigData Data;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void BuildSlotsConfigData()
    {

    }

    public ReelConfig ReelClippingCfg()
    {
        var cfg = new ReelConfig();
        cfg.RcList = Data.RcList;
        cfg.RcType = Data.ViewType;
        cfg.RcLineWidth = Data.LineWidth;
        cfg.RcItemWidth = Data.CellWidth;
        cfg.RcItemHeight = Data.CellHeight;
        cfg.RcWidth = Data.RowWidth;
        cfg.RcHeight = Data.ColHeight;
        return cfg;
    }

    public ReelConfig ReelClippingWishCfg()
    {
        var cfg = new ReelConfig();
        cfg.RcList = Data.RcListWish;
        cfg.RcType = Data.ViewType;
        cfg.RcLineWidth = Data.LineWidth;
        cfg.RcItemWidth = Data.CellWidth;
        cfg.RcItemHeight = Data.CellHeight;
        cfg.RcWidth = Data.RowWidth;
        cfg.RcHeight = Data.ColHeight;
        return cfg;
    }

    public int DefaultSlotsByRC(int col, int row)
    {
        return Data.ElementInitList[col][row];
    }

    public HUGEUnit ElementById(int slotsId)
    {
        foreach (var unit in Data.ElementUnitList)
        {
            if (unit.Id == slotsId)
            {
                return unit;
            }
        }
        return null;

    }
}
