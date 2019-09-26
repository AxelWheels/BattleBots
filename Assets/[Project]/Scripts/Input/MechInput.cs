using UnityEngine;
using UnityEngine.InputSystem;
using KinematicCharacterController;

namespace BattleBots
{
	internal class MechInput : MonoBehaviour, InputActions.IMechActions
	{
		[Header("Speed")]
		[SerializeField] private float moveSpeed = 10.0f;
		[SerializeField] private float airMoveMultiplier = 0.75f;
		[SerializeField] private float turnSpeed = 12.0f;

		[Header("Components")]
		[SerializeField] private Animator animator = null;

		private InputActions inputActions;

		private Vector2 movementInput = Vector2.zero;

		private void Awake()
		{
			inputActions = new InputActions();
			inputActions.Mech.SetCallbacks(this);
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

		public void OnHeavyAttack(InputAction.CallbackContext context)
		{
			Debug.Log("HeavyAttack");
		}

		public void OnBlock(InputAction.CallbackContext context)
		{
			Debug.Log("Block");
		}
	}
}
