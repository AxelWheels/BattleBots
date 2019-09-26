using UnityEngine;
using UnityEngine.InputSystem;

namespace BattleBots
{

	[RequireComponent(typeof(MechInput))]
	internal class PlayerMech : PlayerBase
	{
		private MechInput mechInput;

		protected override void Start()
		{
			base.Start();

			mechInput = GetComponent<MechInput>();

			mechInput.Dash += Dash;
			mechInput.Move += Movement;
		}

		private void FixedUpdate()
		{
			//Movement requires to be done in update
			movementInput = mechInput.MovementInput;
		}

		public override void Dash(InputAction.CallbackContext context)
		{
			throw new System.NotImplementedException();
		}

		public override void Movement(InputAction.CallbackContext context)
		{
		}
	}
}
