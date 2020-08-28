using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUGEReelMgr : MonoBehaviour
{
    public HUGEMachineLayerMgr MachineMgr { get; set; }

    private ArrayList reelArr = new ArrayList();
    private HUGEClippingView slotsLayer;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void InitReel()
    {
        for (int i = 0; i < int.MaxValue; i++)
        {
            var reelItemArr = new List<GameObject>();
            reelArr.Add(reelItemArr);
        }
    }

    public void CreateSlotsLayer()
    {
        if (!slotsLayer)
        {
            var slotsLayerObj = new GameObject();
            var rt = slotsLayerObj.GetComponent<RectTransform>();
            rt.transform.SetParent(gameObject.GetComponent<RectTransform>());
            slotsLayer = slotsLayerObj.AddComponent<HUGEClippingView>();
        }
        InitReel();
    }

    public void StripMove(int colIdx, List<HUGEDriveGear> cellList)
    {
    
    }

    public void StripBegMove(int colIdx, int stopTag, List<int> showTagList)
    {

    }

    public void StripNearStop(int idx)
    {

    }

    public void StripEndStop(int idx)
    {

    }

    public void RefreshNormalModel()
    {
        slotsLayer.ChangeModel(, 0.0f, 0.0f);
    }

    public void RefreshWishModel()
    {
        slotsLayer.ChangeModel(, 0.0f, 0.0f);
    }
}
