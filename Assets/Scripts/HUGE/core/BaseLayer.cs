using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;
using UnityEngine.EventSystems;

[RequireComponent(typeof(RectTransform), typeof(Image))]
public class BaseLayer : MonoBehaviour, IPointerDownHandler, IPointerUpHandler, IPointerExitHandler
{
    public HUGEBottomBarLayerMgr Delegate { get; set; }

    void Awake()
    {
        gameObject.name = "GameLayer";
        var rt = gameObject.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.5f, 0.5f);
        var triggle = gameObject.GetComponent<EventTrigger>();
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if (Delegate)
        {
            Delegate.OnTouchHandler("began");
        }
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        if (Delegate)
        {
            Delegate.OnTouchHandler("ended");
        }
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        if (Delegate)
        {
            //Delegate.OnTouchHandler("cancelled");
        }
    }
}
