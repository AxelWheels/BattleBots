using UnityEngine;

[RequireComponent(typeof(TrailRenderer), typeof(Rigidbody))]
public class ScaleTrailByVelocity : MonoBehaviour
{
    [SerializeField]
    private TrailRenderer m_TrailRenderer;
    [SerializeField]
    private Rigidbody m_Rigidbody;

    [SerializeField]
    private float m_MinSize;
    [SerializeField]
    private float m_MaxSize;

    [SerializeField]
    private float m_MinSpeed;
    [SerializeField]
    private float m_MaxSpeed;

    private Vector3 m_LastPosition;

    private void Update()
    {
        Vector3 lPositionDelta = m_LastPosition - transform.position;
        m_LastPosition = transform.position;

        float lVelocityScale = Mathf.InverseLerp(m_MinSpeed, m_MaxSpeed, lPositionDelta.magnitude);
        m_TrailRenderer.widthMultiplier = Mathf.InverseLerp(m_MinSize, m_MaxSize, lVelocityScale) * lVelocityScale;
    }
}
