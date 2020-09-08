using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform))]
public class HUGEBottomBarLayerMgr : MonoBehaviour
{
    public HUGESlotsMgr Delegate { get; set; }
    private SpinBtnType btnSpinType;
    private bool btnSpinIsEnable;
    private Image btnSpin;

    void Awake()
    {
        var rt = gameObject.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0.0f, 0.0f);
        rt.anchorMax = new Vector2(0.0f, 0.0f);
        rt.pivot = new Vector2(0.0f, 0.0f);
        gameObject.name = "BottomBarLayerMgr";
        btnSpinType = SpinBtnType.BtnNull;
        btnSpinIsEnable = true;
        CreateMenu();
        btnSpinType = SpinBtnType.BtnSpin;
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void RefreshSpinBtnType(SpinBtnType stype, bool enable)
    {
        if (btnSpinType == stype && btnSpinIsEnable == enable)
        {
            return;
        }
        btnSpinType = stype;
        btnSpinIsEnable = enable;
        LoadSpinBtnType(stype, enable);
    }

    public void LoadSpinBtnType(SpinBtnType stype, bool enable)
    {
        switch (stype)
        {
            case SpinBtnType.BtnSpin:
                {
                    if (enable)
                    {
                        btnSpin.sprite = Resources.Load<Sprite>("Pic/spin");
                    }
                    else
                    {
                        btnSpin.sprite = Resources.Load<Sprite>("Pic/spin_dis");
                    }
                    btnSpin.SetNativeSize();
                }
                break;
            case SpinBtnType.BtnStop:
                {
                    if (enable)
                    {
                        btnSpin.sprite = Resources.Load<Sprite>("Pic/stop");
                    }
                    else
                    {
                        btnSpin.sprite = Resources.Load<Sprite>("Pic/stop_dis");
                    }
                    btnSpin.SetNativeSize();
                }
                break;
            case SpinBtnType.BtnFreeSpin:
                {
                    if (enable)
                    {
                        btnSpin.sprite = Resources.Load<Sprite>("Pic/freespin");
                    }
                    else
                    {
                        btnSpin.sprite = Resources.Load<Sprite>("Pic/freespin_dis");
                    }
                    btnSpin.SetNativeSize();
                }
                break;
            case SpinBtnType.BtnAuto:
                {
                    if (enable)
                    {
                        btnSpin.sprite = Resources.Load<Sprite>("Pic/auto");
                    }
                    else
                    {
                        btnSpin.sprite = Resources.Load<Sprite>("Pic/auto_dis");
                    }
                    btnSpin.SetNativeSize();
                }
                break;
            default:
                break;
        }
    }

    public void CreateMenu()
    {
        var btnObj = new GameObject();
        var baseLayer = btnObj.AddComponent<BaseLayer>();
        baseLayer.Delegate = this;
        var rt = btnObj.GetComponent<RectTransform>();
        rt.SetParent(gameObject.GetComponent<RectTransform>(), false);
        Canvas canvas = FindObjectOfType<Canvas>();
        float h = canvas.GetComponent<RectTransform>().rect.height;
        float w = canvas.GetComponent<RectTransform>().rect.width;
        rt.anchoredPosition = new Vector3(w-100, h*0.5f-260, 0.0f);
        btnSpin = btnObj.GetComponent<Image>();
        btnSpin.sprite = Resources.Load<Sprite>("Pic/spin");
        btnSpin.SetNativeSize();
    }

    public void OnTouchHandler(string evtName)
    {
        if (!btnSpinIsEnable)
        {
            return;
        }
        switch (evtName)
        {
            case "began":
                {
                    if (btnSpinIsEnable)
                    {
                        switch (btnSpinType)
                        {
                            case SpinBtnType.BtnSpin:
                                btnSpin.sprite = Resources.Load<Sprite>("Pic/spin_sel");
                                break;
                            case SpinBtnType.BtnStop:
                            case SpinBtnType.BtnFreeSpin:
                            case SpinBtnType.BtnAuto:
                                BtnSpinAction(btnSpinType);
                                break;
                            default:
                                break;
                        }
                    }
                }
                break;
            case "moved":
                break;
            case "ended":
            case "cancelled":
                {
                    if (btnSpinIsEnable && btnSpinType == SpinBtnType.BtnSpin)
                    {
                        BtnSpinAction(btnSpinType);
                    }
                }
                break;
            default:
                break;
        }
    }

    public void BtnSpinAction(SpinBtnType stype)
    {
        btnSpinIsEnable = false;
        LoadSpinBtnType(stype, btnSpinIsEnable);
        if (Delegate)
        {
            Delegate.DelegateBtnSpinAction(btnSpinType);
        }
    }
}
