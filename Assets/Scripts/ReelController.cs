using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReelController : MonoBehaviour
{
    public GameObject cellPrefab;
    public ReelConfig reelConfig;
    private GameObject animLayer;
    private GameObject reelLayer;

    void Awake()
    {
        this.animLayer = GameObject.Find("SlotsReel/AnimLayer");
        this.reelLayer = GameObject.Find("SlotsReel/ReelViewPort/ReelLayer");
        var rt = this.GetComponent<RectTransform>();
        rt.sizeDelta = new Vector2(0, 0);
    }

    // Start is called before the first frame update
    void Start()
    {
        //GameObject cell = Instantiate(this.cellPrefab, new Vector3(0, 0, 0), Quaternion.identity);
        //cell.transform.parent = this.reelLayer.transform;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void InitReel()
    {

    }

    GameObject CreateCell()
    {
        var cell = Instantiate(this.cellPrefab);
        var ctrl = cell.GetComponent<CellController>();
        ctrl.setSprite(null);
        return cell;
    }
}
