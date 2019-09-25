using UnityEngine;
using UnityEngine.InputSystem;

namespace BattleBots
{
	internal class MechInput : MonoBehaviour, InputActions.IMechActions
	{
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
	}
}
