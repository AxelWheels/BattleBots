using System.Collections;
using UnityEngine;

public class TrapBehaviour : MonoBehaviour
{
    [SerializeField]
    private TrapsData m_TrapData;

    //[SerializeField]
    //private Animator m_Animator;

    [SerializeField]
    private ParticleSystem m_AnimationFire;

    [SerializeField]
    private bool m_IsDestroyable = false;

    [SerializeField]
    private bool m_AlwaysOn = false;

    [SerializeField]
    private Collider m_Collider;

    [SerializeField]
    private Renderer m_FireRenderer;

    [SerializeField]
    private float m_EMISValue;

    private Coroutine m_EmissiveRoutine;

    [SerializeField]
    private Animator m_Animator;

    //private TrapStatus m_TrapsStatus;
    private float m_EMISStartValue = 0.74f;
    private bool m_IsActive;
    private int m_CurrentHealth = 0;

    #region Properties

    public TrapsData TrapData
    {
        get
        {
            return m_TrapData;
        }
    }

    public int CurrentHealth
    {
        get
        {
            return m_CurrentHealth;
        }
    }

    #endregion

    public void OnEnable()
    {
        m_IsActive = false;
        m_Collider = GetComponent<Collider>();
        TriggerTrap();
    }

    private void OnTriggerStay(Collider lCollider)
    {
        if (lCollider.tag == "Player")
        {
            if (m_Collider != null)
            {
                int lDamage;
                PlayerController lPlayerController = lCollider.gameObject.GetComponentInParent<PlayerController>();

                if (lPlayerController.DamageReduction > 0)
                {
                    lDamage = Mathf.RoundToInt(-m_TrapData.Damage * Time.deltaTime * lPlayerController.DamageReduction);
                }
                else
                {
                    lDamage = -m_TrapData.Damage;
                }

                lPlayerController.ChangeHealth(m_Collider, lDamage);
                lPlayerController.MakeHitStun(m_TrapData.HitStunTime);
            }
        }
    }

    public void TriggerTrap()
    {
        m_Collider.enabled = true;
        m_IsActive = true;

        if (m_EmissiveRoutine != null)
        {
            StopCoroutine(m_EmissiveRoutine);
        }

        //m_Animator.SetTrigger( "Active" );
        if (TrapData.GetTrapTypes == TrapType.Hades)
        {
            m_EmissiveRoutine = StartCoroutine(IncreaseEMISValue());
            m_Animator.SetTrigger("HeadOpen");
        }

        if (m_AnimationFire != null)
        {
            m_AnimationFire.Play();
        }

        if (!m_AlwaysOn)
        {
            Invoke("DisarmTrap", m_TrapData.ArmedTime);
        }
    }

    public void DisarmTrap()
    {
        m_Collider.enabled = false;
        m_IsActive = false;

        if (m_EmissiveRoutine != null)
        {
            StopCoroutine(m_EmissiveRoutine);
        }
        m_EmissiveRoutine = StartCoroutine(DecreaseEMISValue());

        if (TrapData.GetTrapTypes == TrapType.Hades)
        {
            m_Animator.SetTrigger("HeadClosed");
        }

        //m_Animator.SetTrigger( "Inactive" );
        m_AnimationFire.Stop();
        Invoke("TriggerTrap", m_TrapData.ArmedTime);
    }

    public IEnumerator IncreaseEMISValue()
    {
        Renderer lRend = m_FireRenderer;

        float lEmissive = m_EMISStartValue;

        while (lEmissive < m_EMISValue)
        {
            lEmissive += Time.deltaTime * 10;

            lRend.material.SetFloat("_EMISValue", lEmissive);

            yield return null;
        }

        lRend.material.SetFloat("_EMISValue", m_EMISValue);
    }

    public IEnumerator DecreaseEMISValue()
    {
        if (m_FireRenderer != null)
        {
            Renderer lRend = m_FireRenderer;
            float lEmissive = m_EMISValue;

            while (lEmissive > m_EMISStartValue)
            {
                lEmissive -= Time.deltaTime * 40;

                lRend.material.SetFloat("_EMISValue", lEmissive);

                yield return null;
            }

            lRend.material.SetFloat("_EMISValue", m_EMISStartValue);
        }
    }


}
