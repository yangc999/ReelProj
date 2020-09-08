using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform), typeof(Image), typeof(Button))]
public class BaseLayer : MonoBehaviour
{
    public HUGEBottomBarLayerMgr Delegate { get; set; }

    void Awake()
    {
        gameObject.name = "GameLayer";
        var rt = gameObject.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.5f, 0.5f);
        var btn = gameObject.GetComponent<Button>();
        btn.interactable = true;
        btn.targetGraphic = gameObject.GetComponent<Image>();
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnMouseDown()
    {
        Debug.Log("MouseDown");
    }

    void OnMouseUp()
    {
        Debug.Log("MouseUp");
    }

    void OnMouseEnter()
    {
        Debug.Log("MouseEnter");
    }

    void OnMouseExit()
    {
        Debug.Log("MouseExit");
    }
}
