using UnityEngine;
using UnityEngine.InputSystem;

namespace BattleBots
{
	[RequireComponent(typeof(MechInput))]
	internal class PlayerMech : PlayerBase
	{
		[SerializeField] private Collider[] weaponColliders;
		private MechInput mechInput;
		private GameObject weapon;

		protected override void Start()
		{
			base.Start();

			if(TryGetComponent(out mechInput))
			{
				mechInput.Move += Movement;
				mechInput.Dash += Dash;
				mechInput.Block += Block;
				mechInput.Shoot += Shoot;
				mechInput.LightAttack += LightAttack;
				mechInput.HeavyAttack += HeavyAttack;
			}
			else
			{
				Debug.LogError("Failed to initialise with input");
			}
		}

		private void FixedUpdate()
		{
			//Movement requires to be done in update due to input
			movementInput = mechInput.MovementInput;
		}

		public override void Dash(InputAction.CallbackContext context)
		{
			//throw new System.NotImplementedException();
		}

		public override void Movement(InputAction.CallbackContext context)
		{

		}

		private void Block(InputAction.CallbackContext context)
		{
			Debug.Log($"Block Value {context.performed}");
			AdjustHealthModifier(context.performed ? -1f : 1f);
		}

		private void Shoot(InputAction.CallbackContext context)
		{

		}

		private void LightAttack(InputAction.CallbackContext context)
		{

		}

		private void HeavyAttack(InputAction.CallbackContext context)
		{

		}
	}
}
