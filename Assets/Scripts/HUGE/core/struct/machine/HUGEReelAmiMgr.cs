using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUGEReelAmiMgr : MonoBehaviour
{
    public HUGEMachineLayerMgr MachineMgr { get; set; }

    private List<HUGEVtemAmi> amiCache = new List<HUGEVtemAmi>();
    private HUGEClippingView slotsAmiLayer;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void InitAmiReel()
    {
        foreach (var unit in MachineMgr.DataMgr.Data.ElementUnitList)
        {
            for (int i = 0; i < MachineMgr.DataMgr.Data.Row*5; i++)
            {
                var amiObj = new GameObject();
                amiObj.transform.parent = gameObject.transform;
                var ami = amiObj.AddComponent<HUGEVtemAmi>();
                ami.Init(unit, MachineMgr.DataMgr.Data.CellWidth, MachineMgr.DataMgr.Data.CellHeight);
                ami.Show(false);
                amiCache.Add(ami);
            }
        }
    }

    public void CreateSlotsAmiLayer()
    {
        if (!slotsAmiLayer)
        {
            var slotsAmiLayerObj = new GameObject();
            var rt = slotsAmiLayerObj.GetComponent<RectTransform>();
            rt.transform.SetParent(gameObject.GetComponent<RectTransform>());
            slotsAmiLayer = slotsAmiLayerObj.AddComponent<HUGEClippingView>();
        }
        InitAmiReel();
    }

    public void ClearAmiCacheState()
    {
        if (amiCache.Count != 0)
        {
            foreach (var item in amiCache)
            {
                item.ClearAmiState();
                item.Show(false);
            }
        }
    }

    public void StripMove(int colIdx, List<HUGEDriveGear> cellList)
    {
        if (amiCache.Count != 0)
        {
            foreach (var vtem in amiCache)
            {
                if (vtem.ColIdx == colIdx)
                {
                    foreach (var gear in cellList)
                    {
                        if (vtem.ShowTag == gear.HocTag)
                        {
                            vtem.SetZOrder(gear.HocZOrder);
                            break;
                        }
                    }
                }
            }
        }
    }

    public void StripBegMove(int colIdx, int stopTag, List<int> showTagList)
    {
        if (amiCache.Count != 0)
        {

            for (int i = 0; i < showTagList.Count; i++)
            {
                int showIdx = showTagList[i];
                int slotsId = 0;
                bool inCache = false;
                foreach (var vtem in amiCache)
                {
                    if (vtem.Unit.Id == slotsId && vtem.ColIdx == -1 && vtem.RowIdx == -1)
                    {
                        vtem.ColIdx = colIdx;
                        vtem.RowIdx = i;
                        vtem.ShowTag = showIdx;
                        inCache = true;
                        break;
                    }
                }
                if (!inCache)
                {

                }
            }
        }
    }

    public void StripNearStop(int colIdx)
    {
        if (amiCache.Count != 0)
        {
            foreach (var vtem in amiCache)
            {
                if (vtem.ColIdx == colIdx && vtem.RowIdx != -1 && vtem.ShowTag != -1)
                {
                    if (vtem.Unit.IsFeature())
                    {
                        vtem.Show(true);
                        vtem.PlayAnimation(false, "ami1");
                    }
                }
            }
        }
    }

    public void StripEndStop(int colIdx)
    {
        if (amiCache.Count != 0)
        {
            foreach (var vtem in amiCache)
            {
                if (vtem.ColIdx == colIdx && vtem.RowIdx != -1 && vtem.ShowTag != -1)
                {
                    vtem.Show(true);
                }
            }
        }
    }

    public void RefreshNormalModel()
    {
        slotsAmiLayer.ChangeModel(MachineMgr.DataMgr.ReelClippingCfg(), 0, 0);
    }

    public void RefreshWishModel()
    {
        slotsAmiLayer.ChangeModel(MachineMgr.DataMgr.ReelClippingWishCfg(), 0, 0);
    }
}
