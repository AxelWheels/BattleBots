using UnityEngine;

[CreateAssetMenu(fileName = "CharacterData.asset", menuName = "Onyx/Create CharacterData Object", order = 0)]
public class CharacterData : ScriptableObject
{
    [SerializeField]
    private GameObject m_CharPrefab;

    [SerializeField]
    private int m_Health = 100;
    [SerializeField]
    private float m_TurnSpeed = 360.0f;
    [SerializeField]
    private float m_MoveSpeed = 1.0f;
    [SerializeField]
    private float m_MobilityPower = 1.0f;
    [SerializeField]
    private float m_PilotToMechTime = 1.0f;
    //[SerializeField]
    //private float m_JumpPower = 1.0f;
    [SerializeField]
    private float m_GroundCheckDistance = 0.1f;

    #region Properties
    public GameObject CharPrefab
    {
        get
        {
            return m_CharPrefab;
        }
    }
    public int Health
    {
        get
        {
            return m_Health;
        }
    }

    public float TurnSpeed
    {
        get
        {
            return m_TurnSpeed;
        }
    }

    public float MoveSpeed
    {
        get
        {
            return m_MoveSpeed;
        }
    }

    public float MobilityPower
    {
        get
        {
            return m_MobilityPower;
        }
    }

    //public float JumpPower
    //{
    //	get
    //	{
    //		return m_JumpPower;
    //	}
    //}

    public float PilotToMechTime
    {
        get
        {
            return m_PilotToMechTime;
        }
    }

    public float GroundCheckDistance
    {
        get
        {
            return m_GroundCheckDistance;
        }
    }
    #endregion
}
