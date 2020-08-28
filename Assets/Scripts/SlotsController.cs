using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SlotsController : MonoBehaviour
{
    public SlotsConfig config;
    public GameObject reelPrefab;
    public GameObject reelLayout;
    private List<GameObject> reelList = new List<GameObject>();

    void Awake()
    {
        this.reelLayout = GameObject.Find("SlotsRoot/ReelLayout");
    }

    // Start is called before the first frame update
    void Start()
    {
        foreach (var item in this.config.reelCount)
        {
            var layout = Instantiate(this.reelLayout);
            layout.transform.SetParent(this.transform);
            for (int i = 0; i < item; i++)
            {
                ReelConfig reelConfig = this.config.reelConfigs[i];
                var reel = CreateReel(reelConfig);
                reel.transform.SetParent(layout.transform);
                this.reelList.Add(reel);
            }
        }
    }

    // Update is called once per frame
    void Update()
    {

    }

    GameObject CreateReel(ReelConfig config)
    {
        var reel = Instantiate(this.reelPrefab);
        reel.GetComponent<ReelController>().reelConfig = config;
        return reel;
    }
}
