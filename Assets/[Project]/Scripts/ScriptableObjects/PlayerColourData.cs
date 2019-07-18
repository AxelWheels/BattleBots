using UnityEngine;

[CreateAssetMenu(fileName = "PlayerColourData.asset", menuName = "Onyx/Create PlayerColourData object", order = 0)]
public class PlayerColourData : ScriptableObject
{
    [SerializeField] private Color m_Colour;
    [SerializeField] private Sprite m_MechIcon;
    [SerializeField] private Sprite m_PilotIcon;
    [SerializeField] private string m_ColourName;
    [SerializeField] private float m_MatColour;

    public Color PColour { get { return m_Colour; } set { m_Colour = value; } }
    public Sprite MechAvatar { get { return m_MechIcon; } set { m_MechIcon = value; } }
    public Sprite PilotAvatar { get { return m_PilotIcon; } set { m_PilotIcon = value; } }
    public string ColourName { get { return m_ColourName; } set { m_ColourName = value; } }
    public float MatColour { get { return m_MatColour; } set { m_MatColour = value; } }
}
