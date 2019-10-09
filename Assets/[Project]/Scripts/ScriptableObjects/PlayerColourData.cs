using UnityEngine;

[CreateAssetMenu(fileName = "PlayerColourData.asset", menuName = "Onyx/Create PlayerColourData object", order = 0)]
public class PlayerColourData : ScriptableObject
{
    [SerializeField] private Color colour;
    [SerializeField] private Sprite mechIcon;
    [SerializeField] private Sprite pilotIcon;
    [SerializeField] private string colourName;
    [SerializeField] private float matColour;

    public Color PlayerColor { get { return colour; } set { colour = value; } }
    public Sprite MechAvatar { get { return mechIcon; } set { mechIcon = value; } }
    public Sprite PilotAvatar { get { return pilotIcon; } set { pilotIcon = value; } }
    public string ColourName { get { return colourName; } set { colourName = value; } }
    public float MatColour { get { return matColour; } set { matColour = value; } }
}
