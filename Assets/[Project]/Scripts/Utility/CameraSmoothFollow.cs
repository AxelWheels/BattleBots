using UnityEngine;
using System.Collections;
public class CameraSmoothFollow : MonoBehaviour
{
	[SerializeField] private Transform hostTransform;
	[SerializeField] private Transform target;

    public Transform Target { set { target = value; } }

    [SerializeField]
    private float moveSpeed = 1.0f;

    [SerializeField]
    private float rotateSpeed = 1.0f;

	private void Start()
	{
		if (hostTransform == null)
		{
			hostTransform = this.transform;
		}
	}

	private void Update()
    {
		if (transform != null)
		{
			hostTransform.position = Vector3.Lerp(transform.position, target.position, Time.deltaTime * moveSpeed);
			hostTransform.rotation = Quaternion.Slerp(transform.rotation, target.rotation, Time.deltaTime * rotateSpeed);
		}
    }

	private IEnumerator FixedTransition(Transform targetTransform)
	{
        yield return new WaitForEndOfFrame();
	}
}