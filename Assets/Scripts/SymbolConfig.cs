using UnityEngine;

[System.Serializable]
public enum ElementType : int
{
    normal = 0,
    significant, 
    wild,
    scatter,
    bonus, 
}

[System.Serializable]
public class SymbolConfig
{
    public string key;
    public ElementType elementType;
    public Sprite cellSprite;
    public AnimType animType;
    public string[] animPath;
}
