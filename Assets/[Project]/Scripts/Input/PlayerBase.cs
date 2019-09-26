﻿using UnityEngine;
using KinematicCharacterController;

namespace BattleBots
{
	public abstract class PlayerBase: MonoBehaviour, ICharacterController
	{
		[SerializeField] protected Vector2 movementInput = Vector2.zero;

		[SerializeField] protected float movementSpeed = 500f;
		[SerializeField] protected float airMovementSpeed = 300f;
		[SerializeField] protected float turnSpeed = 12f;

		protected KinematicCharacterMotor motor = null;

		protected Vector3 accumulatedGravity = Vector3.zero;

		protected int health = 100;

		public abstract void Movement();
		public abstract void Dash();

		/// <summary>
		/// Apply damage to a player
		/// </summary>
		/// <param name="damage">Damage to be dealt</param>
		public virtual void TakeDamage(int damage)
		{
			health = Mathf.Max(0, health - damage);
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
				currentRotation = Quaternion.Slerp(currentRotation, Quaternion.LookRotation(new Vector3(movementInput.x, 0f, movementInput.y), Vector3.up), deltaTime * turnSpeed);
			}
		}

		public virtual void UpdateVelocity(ref Vector3 currentVelocity, float deltaTime)
		{
			if(motor.GroundingStatus.IsStableOnGround)
			{
				currentVelocity = new Vector3(movementInput.x, 0f, movementInput.y) * movementSpeed * deltaTime;
				accumulatedGravity = Vector3.zero;
			}
			else
			{
				currentVelocity = movementInput * airMovementSpeed * deltaTime;

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
