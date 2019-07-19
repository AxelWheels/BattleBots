using UnityEngine;

namespace BattleBots
{
    public class PawnMovement : MonoBehaviour
    {
        [SerializeField] private Animator animator = null;
        [SerializeField] private new Rigidbody rigidbody = null;

        public Vector3 Direction { get; set; } = Vector3.zero;

        protected virtual void FixedUpdate()
        {
            if (Direction.sqrMagnitude > 0.0f)
            {
                transform.rotation = Quaternion.LookRotation(Direction, Vector3.up);
                rigidbody.MovePosition(rigidbody.position + transform.forward * Time.fixedDeltaTime);
            }

            animator.SetFloat("Forward", Direction.magnitude);
            animator.SetFloat("Turn", 0);
        }
    }
}
