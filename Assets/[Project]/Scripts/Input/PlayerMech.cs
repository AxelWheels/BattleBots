using UnityEngine;
using UnityEngine.InputSystem;

namespace BattleBots
{
	[RequireComponent(typeof(MechInput))]
	internal class PlayerMech : PlayerBase
	{
		private MechInput mechInput;
		private GameObject weapon;

		protected override void Start()
		{
			base.Start();

			mechInput = GetComponent<MechInput>();

			mechInput.Dash += Dash;
			mechInput.Move += Movement;
			mechInput.Block += Block;
			mechInput.Shoot += Shoot;
			mechInput.LightAttack += LightAttack;
			mechInput.HeavyAttack += HeavyAttack;
		}

		private void FixedUpdate()
		{
			//Movement requires to be done in update due to input
			movementInput = mechInput.MovementInput;
		}

		public override void Dash(InputAction.CallbackContext context)
		{
			throw new System.NotImplementedException();
		}

		public override void Movement(InputAction.CallbackContext context)
		{

		}

		private void Block(InputAction.CallbackContext context)
		{
			if (context.performed)
			{
				AdjustHealthModifier(1f);
			}
			else
			{
				AdjustHealthModifier(-1f);
			}
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
