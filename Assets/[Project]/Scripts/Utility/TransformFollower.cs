using UnityEngine;
using System.Collections;

public class TransformFollower : MonoBehaviour
{
	[SerializeField] private Transform hostTransform;
	[SerializeField] private Transform target;

	[SerializeField] private AnimationCurve animationCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);

    [SerializeField] private float moveSpeed = 10.0f;
    [SerializeField] private float rotateSpeed = 10.0f;
	
	private bool transitioning = false;
    public Transform Target { set { target = value; } }

	private void Start()
	{
		if (hostTransform == null)
		{
			hostTransform = this.transform;
		}
	}

	private void Update()
    {
		if (transform != null && !transitioning)
		{
			hostTransform.position = Vector3.Lerp(transform.position, target.position, Time.deltaTime * moveSpeed);
			hostTransform.rotation = Quaternion.Slerp(transform.rotation, target.rotation, Time.deltaTime * rotateSpeed);
		}
    }

	private void FixedTransition(float duration)
	{
		StartCoroutine(FixedTransitionRoutine(duration));
	}

	private IEnumerator FixedTransitionRoutine(float duration)
	{
		transitioning = true;

		float timer = 0f;

		Vector3 originalPosition = hostTransform.position;
		Quaternion originalRotation = hostTransform.rotation;

		while (timer <= duration)
		{
			timer += Time.deltaTime;

			float animValue = timer / duration;

			hostTransform.position = Vector3.Lerp(originalPosition, target.transform.position, animValue);
			hostTransform.rotation = Quaternion.Slerp(originalRotation, target.rotation, animValue);

			yield return null;
		}

		transitioning = false;
	}
}