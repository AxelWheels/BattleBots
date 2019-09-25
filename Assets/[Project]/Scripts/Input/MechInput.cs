using UnityEngine;
using UnityEngine.InputSystem;
using KinematicCharacterController;

namespace BattleBots
{
	internal class MechInput : MonoBehaviour, InputActions.IMechActions, ICharacterController
	{
		[Header("Speed")]
		[SerializeField] private float moveSpeed = 10.0f;
		[SerializeField] private float airMoveMultiplier = 0.75f;
		[SerializeField] private float turnSpeed = 12.0f;

		[Header("Components")]
		[SerializeField] private Animator animator = null;

		private InputActions inputActions;

		private KinematicCharacterMotor motor = null;

		private Vector3 accumulatedGravity = Vector3.zero;

		private Vector2 movementInput = Vector2.zero;

		private void Awake()
		{
			motor = GetComponent<KinematicCharacterMotor>();

			inputActions = new InputActions();
			inputActions.Mech.SetCallbacks(this);
		}

		private void Start()
		{
			motor.CharacterController = this;
		}

		private void OnEnable()
		{
			inputActions.Mech.Enable();
		}

		private void OnDisable()
		{
			inputActions.Mech.Disable();
		}

		private void Update()
		{
			movementInput = inputActions.Mech.Movement.ReadValue<Vector2>();
			
			Debug.Log(movementInput);
		}

		public void OnMovement(InputAction.CallbackContext context)
		{
			Debug.Log("Movement");
		}

		public void OnLightAttack(InputAction.CallbackContext context)
		{
			Debug.Log("LightAttack");
		}

		public void OnShoot(InputAction.CallbackContext context)
		{
			Debug.Log("Shoot");
		}

		public void OnDash(InputAction.CallbackContext context)
		{
			Debug.Log("Dash");
		}

		public void UpdateRotation(ref Quaternion currentRotation, float deltaTime)
		{
			if (movementInput.sqrMagnitude > 0f)
			{
				currentRotation = Quaternion.Slerp(currentRotation, Quaternion.LookRotation(new Vector3(movementInput.x, 0f, movementInput.y), Vector3.up), deltaTime * turnSpeed);
			}
		}

		public void UpdateVelocity(ref Vector3 currentVelocity, float deltaTime)
		{
			currentVelocity.x = movementInput.x * moveSpeed;
			currentVelocity.z = movementInput.y * moveSpeed;
		}

		public void BeforeCharacterUpdate(float deltaTime)
		{
		}

		public void PostGroundingUpdate(float deltaTime)
		{
		}

		public void AfterCharacterUpdate(float deltaTime)
		{
		}

		public bool IsColliderValidForCollisions(Collider coll)
		{
			return true;
		}

		public void OnGroundHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport)
		{
		}

		public void OnMovementHit(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, ref HitStabilityReport hitStabilityReport)
		{
		}

		public void ProcessHitStabilityReport(Collider hitCollider, Vector3 hitNormal, Vector3 hitPoint, Vector3 atCharacterPosition, Quaternion atCharacterRotation, ref HitStabilityReport hitStabilityReport)
		{
		}

		public void OnDiscreteCollisionDetected(Collider hitCollider)
		{
		}
	}
}
