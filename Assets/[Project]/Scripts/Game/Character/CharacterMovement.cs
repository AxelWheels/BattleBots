using System.Collections;
using UnityEngine;


public class CharacterMovement : MonoBehaviour
{
    [SerializeField] private float turnSpeed = 360f;
    [SerializeField] private float rollPower = 12f;
    [SerializeField] private float rocketPower = 10f;
    [SerializeField] private float groundCheckDistance;

    [SerializeField, Range(1f, 100f)]
    private float moveSpeedMultiplier = 1f;

    [SerializeField, Range(1f, 5f)]
    private float animSpeedMultiplier = 1f;

    private PlayerController playerController;
    private Rigidbody rigidbody;
    private Animator animator;
    private CapsuleCollider capsule;
    private Vector3 groundNormal;
    private Vector3 deltaPosition;
    private Vector3 lastPosition = Vector3.zero;

    private float origGroundCheckDistance;
    private float capsuleHeight;
    private bool boosting;

    #region Properties

    public PlayerController Controller { get; set; }

    public bool Grounded { get { return Physics.Raycast(transform.position + Vector3.up * capsuleHeight, Vector3.down, capsuleHeight + groundCheckDistance); } }

    public float TurnSpeed { get { return turnSpeed; } }
    public float RollPower { get { return rollPower; } }
    public float RocketPower { get { return rocketPower; } }
    public float MoveSpeedMultiplier { get { return moveSpeedMultiplier; } set { moveSpeedMultiplier = value; } }
    public float AnimSpeedMultiplier { get { return animSpeedMultiplier; } }
    public float GroundCheckDistance { get { return groundCheckDistance; } }
    public bool Boosting { get { return boosting; } }
    #endregion

    private void Awake()
    {
        capsule = GetComponentInChildren<CapsuleCollider>();
    }

    private void Start()
    {
        playerController = GetComponent<PlayerController>();
        rigidbody = GetComponent<Rigidbody>();
        capsuleHeight = capsule.bounds.extents.y * 0.5f;
    }

    public void UpdateAnimator(Animator lAnimator, Vector3 lMove)
    {
        lAnimator.SetFloat("Forward", lMove.magnitude);
        lAnimator.SetFloat("Turn", 0);
    }

    public void Move(Vector3 lDirection)
    {
        if (lDirection.magnitude > 0)
        {
            Quaternion lDirectionRotation = Quaternion.LookRotation(lDirection, Vector3.up);

            Vector3 lRelativeDirection = lDirectionRotation * (lDirection.magnitude * transform.forward * moveSpeedMultiplier);

            rigidbody.MovePosition(rigidbody.position + lRelativeDirection * Time.fixedDeltaTime);

            //Set the currently active mech/pilot to the same rotation as the PlayerController object
            Controller.ActiveObject.transform.rotation = Quaternion.Slerp(Controller.ActiveObject.transform.rotation, lDirectionRotation, Time.fixedDeltaTime * turnSpeed);

            UpdateActiveObject();
        }

        DampenRigidbodyVelocity();
    }

    public void UpdateActiveObject()
    {
        UpdateAnimator(Controller.Animator, rigidbody.velocity);
        if (Controller.transform.localRotation != Quaternion.identity)
        {
            Controller.ActiveObject.transform.localRotation = Quaternion.identity;
        }
    }

    private void DampenRigidbodyVelocity()
    {
        if (rigidbody.velocity.magnitude > Controller.MaxVelocity)
        {
            Vector3 lAllowedVelocity = Vector3.ClampMagnitude(rigidbody.velocity, Controller.MaxVelocity);

            Vector3 lDampenedVelocity = rigidbody.velocity - lAllowedVelocity;

            lDampenedVelocity *= Controller.VelocityDampening;

            rigidbody.velocity = lAllowedVelocity + lDampenedVelocity;
        }
    }

    public void DodgeRoll()
    {
        if (Grounded)
        {
            rigidbody.AddForce(Controller.ActiveObject.transform.forward * RollPower, ForceMode.Impulse);
            StartCoroutine(Invincible(Controller.InvincibilityData.DodgeTime));
        }
    }

    public void RocketBoost(float lTime)
    {
        StartCoroutine(BoostRoutine(lTime));
    }

    private IEnumerator BoostRoutine(float lTime)
    {
        if (Controller.BoostEffect != null)
        {
            Controller.BoostEffect.SetActive(true);
        }

        Controller.CanInput = false;
        rigidbody.AddForce((Controller.ActiveObject.transform.forward * RocketPower) + (Grounded ? Vector3.zero : (Controller.ActiveObject.transform.up * RocketPower)), ForceMode.VelocityChange);
        yield return new WaitForSeconds(lTime);
        Controller.CanInput = true;
        animator.SetTrigger("Landing");

        yield return new WaitForSeconds(lTime);

        if (Controller.BoostEffect != null)
        {
            Controller.BoostEffect.SetActive(false);
        }
    }

    //public void Jump( float lJumpPower )
    //{
    //	if( Grounded )
    //	{
    //		m_Rigidbody.AddForce( Vector3.up * lJumpPower, ForceMode.Impulse );
    //	}
    //}

    public IEnumerator Invincible(float lSeconds)
    {
        Controller.IsInvincible = true;
        yield return new WaitForSeconds(lSeconds);
        Controller.IsInvincible = false;
    }

    public IEnumerator HitStun(float lSeconds)
    {
        Controller.IsHitStun = true;

        if (Controller.IsMech)
        {
            Transform lTransform = Controller.ActiveObject.GetComponent<CharacterAttackJoint>().MeleeAttackObjectRoot;

            for (int i = 0; i < lTransform.childCount; i++)
            {
                Destroy(lTransform.GetChild(i).gameObject);
            }
        }

        yield return new WaitForSeconds(lSeconds);
        Controller.IsHitStun = false;
    }

    public void UpdateData(CharacterData lData, GameObject lActiveObject)
    {
        turnSpeed = lData.TurnSpeed;
        rollPower = lData.MobilityPower;
        moveSpeedMultiplier = lData.MoveSpeed;

        animator = lActiveObject.GetComponentInChildren<Animator>();
        capsule = lActiveObject.GetComponent<CapsuleCollider>();

        origGroundCheckDistance = lData.GroundCheckDistance;
    }

    private void OnDrawGizmos()
    {
        Gizmos.DrawRay(transform.position + Vector3.up * capsuleHeight, Vector3.down * (capsuleHeight + groundCheckDistance));
    }

    public IEnumerator ChangeMoveSpeedTemporarily(float lValue, float lSeconds)
    {
        moveSpeedMultiplier += lValue;
        yield return new WaitForSeconds(lSeconds);
        moveSpeedMultiplier -= lValue;
    }
}
