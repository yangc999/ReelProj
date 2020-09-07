using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class HUGEReelAmiMgr : MonoBehaviour
{
    public HUGEMachineLayerMgr MachineMgr { get; set; }

    private List<HUGEVtemAmi> amiCache = new List<HUGEVtemAmi>();
    private HUGEClippingView slotsAmiLayer;

    void Awake()
    {
        var rt = gameObject.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.0f, 0.0f);
        gameObject.name = "ReelAmiMgr";
    }

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
                var ami = amiObj.AddComponent<HUGEVtemAmi>();
                ami.Init(unit, MachineMgr.DataMgr.Data.CellWidth, MachineMgr.DataMgr.Data.CellHeight);
                var rt = amiObj.GetComponent<RectTransform>();
                rt.SetParent(slotsAmiLayer.gameObject.GetComponent<RectTransform>(), false);
                ami.Show(false);
                amiCache.Add(ami);
            }
        }
        Debug.Log("ReelAmi Init");
    }

    public void CreateSlotsAmiLayer()
    {
        if (!slotsAmiLayer)
        {
            var slotsAmiLayerObj = new GameObject();
            slotsAmiLayerObj.name = "SlotsAmiLayer";
            slotsAmiLayer = slotsAmiLayerObj.AddComponent<HUGEClippingView>();
            var rt = slotsAmiLayerObj.GetComponent<RectTransform>();
            rt.SetParent(gameObject.GetComponent<RectTransform>(), false);
            Canvas canvas = FindObjectOfType<Canvas>();
            float h = canvas.GetComponent<RectTransform>().rect.height;
            float w = canvas.GetComponent<RectTransform>().rect.width;
            rt.anchoredPosition = new Vector3(w*0.5f, h*0.5f, 0.0f);
            slotsAmiLayer.Init(MachineMgr.DataMgr.ReelClippingCfg(), 50.0f, 50.0f);
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

    public void StripBegStop(int colIdx, int stopTag, List<int> showTagList, List<List<int>> trueStrips)
    {
        var trueList = MachineMgr.DataMgr.Data.TrueStrips[colIdx];
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
                    var unit = MachineMgr.DataMgr.ElementById(slotsId);
                    var amiObj = new GameObject();
                    var ami = amiObj.AddComponent<HUGEVtemAmi>();
                    ami.Init(unit, MachineMgr.DataMgr.Data.CellWidth, MachineMgr.DataMgr.Data.CellHeight);
                    amiCache.Add(ami);
                    ami.ColIdx = colIdx;
                    ami.RowIdx = i;
                    ami.ShowTag = showIdx;
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
