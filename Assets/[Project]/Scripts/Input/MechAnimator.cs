using UnityEngine;
using UnityEngine.InputSystem;

namespace BattleBots
{
	[RequireComponent(typeof(MechInput))]
	internal class MechAnimator : MonoBehaviour 
	{
		[SerializeField] private Animator animatorComponent;

		private MechInput mechInput;

		private void Start()
		{
			mechInput = GetComponent<MechInput>();
			mechInput.Move += Move;
			mechInput.Dash += Dash;
			mechInput.Block += Block;
		}

		private void Update()
		{
		}

		private void Move(InputAction.CallbackContext context)
		{
			animatorComponent.SetFloat("Speed", context.ReadValue<Vector2>().magnitude);
		}

		private void Dash(InputAction.CallbackContext context)
		{
			animatorComponent.SetBool("Dashing", context.performed);
		}

		private void Block(InputAction.CallbackContext context)
		{
			animatorComponent.SetBool("Blocking", context.performed);
		}
	}
}
