using KinematicCharacterController;
using UnityEngine;
using System.Collections;

namespace BattleBots
{
    [RequireComponent(typeof(KinematicCharacterMotor))]
    public class PawnMovement : MonoBehaviour, ICharacterController
    {
        [Header("Speed")]
        [SerializeField] private float moveSpeed = 200.0f;
        [SerializeField] private float airMoveMultiplier = 0.75f;
        [SerializeField] private float turnSpeed = 12.0f;

        [Header("Components")]
        [SerializeField] private Animator animator = null;

        private KinematicCharacterMotor motor = null;
        private Vector3 accumulatedGravity = Vector3.zero;

        public Vector3 Direction { get; set; } = Vector3.zero;

        protected virtual void Awake()
        {
            motor = GetComponent<KinematicCharacterMotor>();
        }

        protected virtual void Start()
        {
            motor.CharacterController = this;
        }

        void ICharacterController.AfterCharacterUpdate(float deltaTime)
        {
            animator.SetFloat("Forward", Direction.magnitude);
            animator.SetFloat("Turn", 0);
        }

        void ICharacterController.BeforeCharacterUpdate(float deltaTime) { }

        bool ICharacterController.IsColliderValidForCollisions(Collider coll)
        {
            return true;
        }

        void ICharacterController.OnDiscreteCollisionDetected(Collider hitCollider) { }

        void ICharacterController.OnGroundHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport) { }

        void ICharacterController.OnMovementHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport) { }

        void ICharacterController.PostGroundingUpdate(float deltaTime) { }

        void ICharacterController.ProcessHitStabilityReport(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, Vector3 atCharacterPosition, Quaternion atCharacterRotation, ref HitStabilityReport hitStabilityReport) { }

        void ICharacterController.UpdateRotation(ref Quaternion currentRotation, float deltaTime)
        {
            if (Direction.sqrMagnitude > 0.0f)
            {
                currentRotation = Quaternion.Slerp(currentRotation, Quaternion.LookRotation(Direction, Vector3.up), deltaTime * turnSpeed);
            }
        }

        void ICharacterController.UpdateVelocity(ref Vector3 currentVelocity, float deltaTime)
        {
            if (motor.GroundingStatus.IsStableOnGround)
            {
                currentVelocity = Direction * moveSpeed * deltaTime;
                accumulatedGravity = Vector3.zero;
            }
            else
            {
                currentVelocity = Direction * moveSpeed * deltaTime * airMoveMultiplier;

                accumulatedGravity += Physics.gravity * deltaTime;
                currentVelocity += accumulatedGravity;
            }
        }
    }
}
