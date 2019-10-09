using UnityEngine;
using UnityEngine.InputSystem;

namespace BattleBots
{
	//TODO: Add in correct animation calls for other input

	[RequireComponent(typeof(MechInput))]
	internal class MechAnimator : MonoBehaviour 
	{
		[SerializeField] private Animator animatorComponent = null;

		private MechInput mechInput;

		private void Start()
		{
			mechInput = GetComponent<MechInput>();

			mechInput.Move += Move;
			mechInput.Dash += Dash;
			mechInput.Block += Block;
			mechInput.Shoot += Shoot;
			mechInput.LightAttack += LightAttack;
			mechInput.HeavyAttack += HeavyAttack;
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

		private void Shoot(InputAction.CallbackContext context)
		{
			animatorComponent.SetBool("Blocking", context.performed);
		}

		private void LightAttack(InputAction.CallbackContext context)
		{
			animatorComponent.SetBool("Blocking", context.performed);
		}

		private void HeavyAttack(InputAction.CallbackContext context)
		{
			animatorComponent.SetBool("Blocking", context.performed);
		}
	}
}
