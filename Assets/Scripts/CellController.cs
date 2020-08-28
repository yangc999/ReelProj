using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CellController : MonoBehaviour
{
    private Image img;

    void Awake()
    {
        this.img = GameObject.Find("SlotsCell/Image").GetComponent<Image>();
        var rt = this.GetComponent<RectTransform>();
        rt.sizeDelta = new Vector2(0, 0);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        var rect = this.GetComponent<RectTransform>();
        rect.localPosition += new Vector3();
    }


    public void setSprite(Sprite spr)
    {
        this.img.sprite = spr;
        this.img.SetNativeSize();
    }

    public void MaskEnabled(bool flag)
    {
        var mask = this.GetComponent<Mask>();
        mask.enabled = flag;
    }
}
