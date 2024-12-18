using UnityEngine;
using KinematicCharacterController;
using UnityEngine.InputSystem;

namespace BattleBots
{
	public abstract class PlayerBase: MonoBehaviour, ICharacterController
	{
		[SerializeField] protected CharacterData characterData;

		protected KinematicCharacterMotor motor = null;

		protected Vector3 accumulatedGravity = Vector3.zero;

		protected Vector2 movementInput = Vector2.zero;

		protected int health = 100;

		protected float healthModifier = 1f;

		public abstract void Movement(InputAction.CallbackContext context);
		public abstract void Dash(InputAction.CallbackContext context);

		/// <summary>
		/// Apply damage to a player
		/// </summary>
		/// <param name="damage">Damage to be dealt</param>
		public virtual void TakeDamage(int damage)
		{
			health = Mathf.Max(0, health - (int)(damage * healthModifier));
		}

		public virtual void AdjustHealthModifier(float adjustment)
		{
			healthModifier += adjustment;
		}

		protected virtual void Awake()
		{
			motor = GetComponent<KinematicCharacterMotor>();
		}

		protected virtual void Start()
		{
			motor.CharacterController = this;
		}
		
		public virtual void UpdateRotation(ref Quaternion currentRotation, float deltaTime)
		{
			if(movementInput.sqrMagnitude > 0f)
			{
				currentRotation = Quaternion.Slerp(currentRotation, Quaternion.LookRotation(new Vector3(movementInput.x, 0f, movementInput.y), Vector3.up), deltaTime * characterData.TurnSpeed);
			}
		}

		public virtual void UpdateVelocity(ref Vector3 currentVelocity, float deltaTime)
		{
			if(motor.GroundingStatus.IsStableOnGround)
			{
				currentVelocity = new Vector3(movementInput.x, 0f, movementInput.y) * characterData.MovementSpeed * deltaTime;
				accumulatedGravity = Vector3.zero;
			}
			else
			{
				currentVelocity = movementInput * characterData.AirMovementSpeed * deltaTime;

				accumulatedGravity += Physics.gravity * deltaTime;
				currentVelocity += accumulatedGravity;
			}
		}

		public virtual void BeforeCharacterUpdate(float deltaTime)
		{
		}

		public virtual void PostGroundingUpdate(float deltaTime)
		{
		}

		public virtual void AfterCharacterUpdate(float deltaTime)
		{
		}

		public virtual bool IsColliderValidForCollisions(Collider coll)
		{
			return true;
		}

		public virtual void OnGroundHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport)
		{
		}

		public virtual void OnMovementHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport)
		{
		}

		public virtual void ProcessHitStabilityReport(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, Vector3 atCharacterPosition, Quaternion atCharacterRotation, ref HitStabilityReport hitStabilityReport)
		{
		}

		public virtual void OnDiscreteCollisionDetected(Collider hitCollider)
		{
		}
	}
}
