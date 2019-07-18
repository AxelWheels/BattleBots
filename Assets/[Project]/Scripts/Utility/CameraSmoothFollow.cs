using UnityEngine;

public class CameraSmoothFollow : MonoBehaviour
{
    [SerializeField]
    private Transform m_Target;

    [SerializeField]
    private float m_MoveSpeed = 1.0f;

    [SerializeField]
    private float m_RotateSpeed = 1.0f;

    private void LateUpdate()
    {
        transform.position = Vector3.Lerp(transform.position, m_Target.position, Time.deltaTime * m_MoveSpeed);
        transform.rotation = Quaternion.Slerp(transform.rotation, m_Target.rotation, Time.deltaTime * m_RotateSpeed);
    }
}
