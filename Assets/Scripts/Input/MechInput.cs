using UnityEngine;
using UnityEngine.InputSystem;
using KinematicCharacterController;

namespace BattleBots
{
	internal class MechInput : MonoBehaviour, InputActions.IMechActions
	{
		private InputActions inputActions;

		private Vector2 movementInput = Vector2.zero;

		public delegate void InputCallback(InputAction.CallbackContext context);

		public InputCallback Move;
		public InputCallback Dash;
		public InputCallback LightAttack;
		public InputCallback HeavyAttack;
		public InputCallback Shoot;
		public InputCallback Block;

		public Vector2 MovementInput => movementInput;

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
		}

		public void OnMovement(InputAction.CallbackContext context)
		{
			Debug.Log("Movement");
			Move?.Invoke(context);
		}

		public void OnLightAttack(InputAction.CallbackContext context)
		{
			Debug.Log("LightAttack");
			LightAttack?.Invoke(context);
		}

		public void OnShoot(InputAction.CallbackContext context)
		{
			Debug.Log("Shoot");
			Shoot?.Invoke(context);
		}

		public void OnDash(InputAction.CallbackContext context)
		{
			Debug.Log("Dash");
			Dash?.Invoke(context);
		}

		public void OnHeavyAttack(InputAction.CallbackContext context)
		{
			Debug.Log("HeavyAttack");
			HeavyAttack?.Invoke(context);
		}

		public void OnBlock(InputAction.CallbackContext context)
		{
			Debug.Log("Block");
			Block?.Invoke(context);
		}
	}
}
