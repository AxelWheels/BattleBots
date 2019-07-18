using System.Collections;
using UnityEngine;

public class AttackObject : MonoBehaviour
{
    [Header("Stats")]
    [SerializeField] private AttackData attackData = null;

    [Header("VFX")]
    [SerializeField] private GameObject hitEffect = null;
    [SerializeField] private GameObject fireEffect = null;

    [Header("Audio")]
    [SerializeField] private SoundData soundData = null;
    [SerializeField] private string attackSound = string.Empty;
    [SerializeField] private AudioSource audioSource = null;
    [SerializeField] private AudioClip attackClip = null;
    [SerializeField] private AudioClip hitClip = null;

    private float activeTime;

    public float TimeTillStart { get; set; }
    public AttackData AttackData { get { return attackData; } }
    public Collider OwnerCollider { get; set; }

    private void Start()
    {
        activeTime = attackData.ActiveTime;
        TimeTillStart = attackData.StartUpTime;

        if (TimeTillStart > 0)
        {
            GetComponent<Collider>().enabled = false;
        }

        if (attackData.ProjectileSpeed > 0)
        {
            //GetComponent<Rigidbody>().velocity = transform.forward * m_AttackData.ProjectileSpeed * Time.fixedDeltaTime;
            GetComponent<Rigidbody>().velocity.Set(0f, 0f, 0f);
            GetComponent<Collider>().enabled = false;
            transform.GetChild(0).gameObject.SetActive(false);

            Invoke("RangedStartTime", attackData.StartUpTime);
        }
    }

    private void Update()
    {
        if (TimeTillStart <= 0)
        {
            GetComponent<Collider>().enabled = true;
        }

        if (activeTime <= 0)
        {
            //if m_AreaOfEffect != null )
            GetComponent<SphereCollider>().radius = 5f;
            Destroy(gameObject);
        }

        activeTime = Mathf.Max(0f, activeTime - Time.deltaTime);
        TimeTillStart = Mathf.Max(0f, TimeTillStart - Time.deltaTime);

    }

    private void OnTriggerEnter(Collider lObject)
    {
        if (lObject == OwnerCollider || lObject.tag == "Trap")
        {
            //Debug.Log( "Hit self, return" );
            return;
        }

        PlayerController lPlayerController = lObject.GetComponentInParent<PlayerController>();
        PlayerController lOwnerController = OwnerCollider.GetComponentInParent<PlayerController>();

        if (lObject.tag == "Player")
        {

            if (!lPlayerController.IsInvincible)
            {
                if (lPlayerController != null)
                {
                    int lDamage = 0;

                    if (lPlayerController.IsBlocking)
                    {
                        if (lPlayerController.DamageReduction > 0)
                        {
                            lDamage = Mathf.RoundToInt(-attackData.Damage * lOwnerController.DamageMultiplier * lPlayerController.DamageReduction * lPlayerController.BlockReduction);
                            lPlayerController.ChangeHealth(OwnerCollider, lDamage);
                        }
                        else
                        {
                            lDamage = Mathf.RoundToInt(-attackData.Damage * lOwnerController.DamageMultiplier * lPlayerController.BlockReduction);
                            lPlayerController.ChangeHealth(OwnerCollider, lDamage);
                        }
                    }
                    else
                    {
                        if (lPlayerController.DamageReduction > 0)
                        {
                            lDamage = Mathf.RoundToInt(-attackData.Damage * lOwnerController.DamageMultiplier * lPlayerController.DamageReduction);
                            lPlayerController.ChangeHealth(OwnerCollider, lDamage);
                        }
                        else
                        {
                            lDamage = Mathf.RoundToInt(-attackData.Damage * lOwnerController.DamageMultiplier);
                            lPlayerController.ChangeHealth(OwnerCollider, lDamage);
                        }
                    }

                    OwnerCollider.GetComponentInParent<PlayerController>().PlayerStats.AddDamageDealt(Mathf.Abs(lDamage));

                    if (attackData.HitStun > 0 && !lPlayerController.IsBlocking)
                    {
                        lPlayerController.MakeHitStun(attackData.HitStun);
                    }
                }

                Rigidbody lRigidbody = lPlayerController.GetComponent<Rigidbody>();

                if (lRigidbody != null)
                {
                    if (attackData.AttackType == eAttackType.BombPlot || attackData.AttackType == eAttackType.Ranged)
                    {
                        lRigidbody.AddForce((lObject.transform.position - gameObject.transform.position).normalized * attackData.Knockback + Vector3.up, ForceMode.Impulse);
                    }
                    else
                    {
                        lRigidbody.AddForce((lObject.transform.position - OwnerCollider.transform.position).normalized * attackData.Knockback + Vector3.up, ForceMode.Impulse);
                    }
                }

                //Play Effects and Sound
                if (hitEffect != null)
                {
                    //EffectsController.Instance.PlayEffectAtPosition( m_HitEffect.name, transform.position, Quaternion.Euler( Vector3.up ) );
                }

                PlayHitSound();

                if (attackData.ProjectileSpeed > 0)
                {
                    //CameraShake.Instance.Shake( 0.1f, 10.0f, 0.5f );
                }
                else
                {
                    //CameraShake.Instance.Shake( 0.01f, 10.0f, 0.5f );
                }

                Vector3 lAttackDirection = OwnerCollider.transform.position - lPlayerController.transform.position;

                //Avoids the player tilting at weird angles
                Vector3 lPlanedDirection = new Vector3(lAttackDirection.x, 0, lAttackDirection.z);

                lPlayerController.ActiveObject.transform.rotation = Quaternion.LookRotation(lPlanedDirection, Vector3.up);
            }

            if (AttackData.AttackType == eAttackType.Ranged)
            {
                if (AttackData.HitRadius > 0f)
                {
                    Rigidbody lRigidbody = lPlayerController.GetComponent<Rigidbody>();
                    GetComponent<SphereCollider>().radius = AttackData.HitRadius;
                    //Debug.Log( "B-A: " + ( lObject.transform.position - gameObject.transform.position ).normalized );
                    Vector3 lForce = lObject.transform.position - gameObject.transform.position;
                    lForce.y = 0;
                    //Debug.Log( "zero y: " + lForce );
                    lRigidbody.AddForce((lForce).normalized * attackData.Knockback + Vector3.up, ForceMode.Impulse);
                }
                Destroy(gameObject);

            }
            else
            {
                Destroy(gameObject);
            }
        }

        else
        {
            if (AttackData.AttackType == eAttackType.Ranged)
            {
                if (AttackData.HitRadius > 0f)
                {
                    if (lPlayerController != null)
                    {
                        Rigidbody lRigidbody = lPlayerController.GetComponent<Rigidbody>();
                        GetComponent<SphereCollider>().radius = AttackData.HitRadius;
                        //Debug.Log( "B-A: " + ( lObject.transform.position - gameObject.transform.position ).normalized );
                        Vector3 lForce = lObject.transform.position - gameObject.transform.position;
                        lForce.y = 0;
                        //Debug.Log( "zero y: " + lForce );
                        lRigidbody.AddForce((lForce).normalized * attackData.Knockback + Vector3.up, ForceMode.Impulse);
                    }
                }
                Destroy(gameObject);
            }

            if (hitEffect != null && attackData.AttackType != eAttackType.BombPlot)
            {
                //EffectsController.Instance.PlayEffectAtPosition( m_HitEffect.name, transform.position, Quaternion.Euler( Vector3.up ) );
            }
        }
    }

    public void PlayAttackSound()
    {
        OwnerCollider.GetComponentInParent<PlayerController>().PlaySound(attackClip);
    }

    public void PlayHitSound()
    {
        OwnerCollider.GetComponentInParent<PlayerController>().PlaySound(hitClip);
    }

    private void RangedStartTime()
    {
        transform.parent = null;
        transform.position = OwnerCollider.GetComponentInParent<PlayerController>().ActiveObject.GetComponent<CharacterAttackJoint>().RangedAttackObjectRoot.position;
        transform.forward = OwnerCollider.GetComponentInParent<PlayerController>().ActiveObject.transform.forward;
        GetComponent<Collider>().enabled = true;
        transform.GetChild(0).gameObject.SetActive(true);
        GetComponent<Rigidbody>().velocity = transform.forward * attackData.ProjectileSpeed * Time.fixedDeltaTime;
    }

    public IEnumerator RangedFireCoroutine(Transform lSpawnPosition, Quaternion lRotation, float lDelayTime)
    {
        if (fireEffect != null)
        {
            yield return new WaitForSeconds(lDelayTime);
            //EffectsController.Instance.PlayEffectAtPosition( m_FireEffect, lSpawnPosition.position, lRotation );
        }
    }

    public void DestroyAndExplode()
    {
        PlayHitSound();
        //EffectsController.Instance.PlayEffectAtPosition( m_HitEffect.name, transform.position, Quaternion.Euler( Vector3.up ) );
        Destroy(gameObject, 0.1f);
    }
}
