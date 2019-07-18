using UnityEngine;

public class CharacterAttackJoint : MonoBehaviour
{
    [SerializeField]
    private Transform m_Joint;
    [SerializeField]
    private Transform m_MeleeAttackObjectRoot;
    [SerializeField]
    private Transform m_RangedAttackObjectRoot;

    [SerializeField]
    private GameObject m_SwordObject;
    [SerializeField]
    private GameObject m_BlockObject;
    [SerializeField]
    private GameObject m_BoostObject;

    public Transform Joint { get { return m_Joint; } }
    public Transform MeleeAttackObjectRoot { get { return m_MeleeAttackObjectRoot; } }
    public Transform RangedAttackObjectRoot { get { return m_RangedAttackObjectRoot; } }
    public GameObject SwordObject { get { return m_SwordObject; } }
    public GameObject BlockObject { get { return m_BlockObject; } }
    public GameObject BoostObject { get { return m_BoostObject; } }

    public void LateUpdate()
    {
        PlayerController lPlayerController = GetComponentInParent<PlayerController>();

        if (lPlayerController.IsMech)
        {
            m_SwordObject.transform.SetParent(m_Joint);
            m_SwordObject.transform.localPosition = Vector3.zero;
        }
        //m_SwordObject.transform.localRotation = Quaternion.identity;
    }
}
