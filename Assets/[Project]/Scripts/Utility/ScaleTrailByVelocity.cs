using UnityEngine;

[RequireComponent(typeof(TrailRenderer), typeof(Rigidbody))]
public class ScaleTrailByVelocity : MonoBehaviour
{
    [SerializeField] private TrailRenderer trailRenderer = null;
    [SerializeField] private new Rigidbody rigidbody = null;

    [SerializeField] private float minSize = 0.0f;
    [SerializeField] private float maxSize = 0.0f;

    [SerializeField] private float minSpeed = 0.0f;
    [SerializeField] private float maxSpeed = 0.0f;

    private Vector3 lastPosition;

    private void Update()
    {
        Vector3 lPositionDelta = lastPosition - transform.position;
        lastPosition = transform.position;

        float lVelocityScale = Mathf.InverseLerp(minSpeed, maxSpeed, lPositionDelta.magnitude);
        trailRenderer.widthMultiplier = Mathf.InverseLerp(minSize, maxSize, lVelocityScale) * lVelocityScale;
    }
}
