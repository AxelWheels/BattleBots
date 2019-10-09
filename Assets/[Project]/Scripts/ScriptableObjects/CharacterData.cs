using UnityEngine;

[CreateAssetMenu(fileName = "CharacterData.asset", menuName = "Onyx/Create CharacterData Object", order = 0)]
public class CharacterData : ScriptableObject
{
    [SerializeField] private GameObject charPrefab = null;

    [SerializeField] private int health = 100;
    [SerializeField] private float turnSpeed = 360.0f;
    [SerializeField] private float moveSpeed = 1.0f;
    [SerializeField] private float mobilityPower = 1.0f;
    [SerializeField] private float pilotToMechTime = 1.0f;
    [SerializeField] private float groundCheckDistance = 0.1f;

    #region Properties
    public GameObject CharPrefab
    {
        get
        {
            return charPrefab;
        }
    }
    public int Health
    {
        get
        {
            return health;
        }
    }

    public float TurnSpeed
    {
        get
        {
            return turnSpeed;
        }
    }

    public float MoveSpeed
    {
        get
        {
            return moveSpeed;
        }
    }

    public float MobilityPower
    {
        get
        {
            return mobilityPower;
        }
    }

    public float PilotToMechTime
    {
        get
        {
            return pilotToMechTime;
        }
    }

    public float GroundCheckDistance
    {
        get
        {
            return groundCheckDistance;
        }
    }
    #endregion
}
