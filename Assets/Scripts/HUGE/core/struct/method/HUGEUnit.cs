using System.Collections;
using System.Collections.Generic;

public class HUGEUnit
{
    public int Id;
    public int Num;
    public SlotsElementType Type;
    public ArrayList Ami = new ArrayList();

    public HUGEUnit()
    {
        Id = 0;
        Num = 1;
        Type = SlotsElementType.Normal;
    }

    public HUGEUnit(HUGEUnit unit)
    {
        Id = unit.Id;
        Num = unit.Num;
        Type = unit.Type;
        foreach (var item in unit.Ami)
        {
            // need deep copy
            Ami.Add(item);
        }
    }

    public bool IsFeature()
    {
        if (Type == SlotsElementType.Scatter ||
            Type == SlotsElementType.Bonus ||
            Type == SlotsElementType.ScatterX ||
            Type == SlotsElementType.ScatterXX ||
            Type == SlotsElementType.ScatterXXX ||
            Type == SlotsElementType.ScatterXXXX)
            return true;
        return false;
    }
}
