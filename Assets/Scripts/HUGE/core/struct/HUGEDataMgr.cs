using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConfigData
{
    public int Id;
    public string Name = "";
    public HocViewType ViewType;
    public int Row;
    public int Col;
    public List<int> RcList = new List<int>();
    public List<int> RcListWish = new List<int>();
    public List<HUGEUnit> ElementUnitList = new List<HUGEUnit>();
    public List<List<int>> ElementInitList = new List<List<int>>();
    public List<List<int>> RollerList = new List<List<int>>();
    public List<List<int>> TrueStrips = new List<List<int>>();
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
    public List<int> RcList = new List<int>();
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

    public void Init()
    {
        Data = new ConfigData();
        BuildSlotsConfigData();
    }

    public void BuildSlotsConfigData()
    {
        var config = Resources.Load<HUGESlotsData>("");
        Data.Id = config.slotsId;
        Data.Name = config.slotsName;
        Data.ViewType = config.viewAlignmentType;
        Data.Row = 3;
        Data.Col = 5;
        Data.RcList = config.rcList;
        Data.RcListWish = config.rcWishList;
        Data.CellWidth = config.viewWidth;
        Data.CellHeight = config.viewHeight;
        Data.LineWidth = config.viewLineWidth;
        Data.CellMaxNum = 1;
        foreach (var item in config.elementArr)
        {
            var unit = new HUGEUnit();
            unit.Id = item.id;
            unit.Num = item.num;
            unit.Type = item.type;
            unit.Ami = item.ami;
            Data.ElementUnitList.Add(unit);
        }
        Data.ViewAnimClipLeftAndRight = config.viewAnimClipLeftAndRight;
        Data.ViewAnimClipTopAndBottom = config.viewAnimClipTopAndBottom;
        Data.ElementInitList = config.initArr;
        Data.RollerList = config.rollerArr;
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
