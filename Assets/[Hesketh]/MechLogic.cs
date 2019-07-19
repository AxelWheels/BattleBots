using UnityEngine;
using UnityEngine.InputSystem;

namespace BattleBots
{
    public class MechLogic : PawnLogic
    {
        [Header("Components")]
        [SerializeField] private PawnMovement pawnMovement = null;

        [Header("Actions")]
        [SerializeField] private InputActionReference move = null;

        /// <summary>
        /// A Vector2 value of the input joysticks x,y state
        /// Should be normalised before this point by the input system
        /// </summary>
        public void Input_Move(InputAction.CallbackContext context)
        {
            Vector2 input = context.ReadValue<Vector2>();
            pawnMovement.Direction = new Vector3(input.x, 0.0f, input.y);
        }

        protected override void DeregisterActions()
        {
            playerInput.actions.FindAction(move.name).performed -= Input_Move;
            playerInput.actions.FindAction(move.name).canceled -= Input_Move;
        }

        protected override void RegisterActions()
        {
            playerInput.actions.FindAction(move.name).performed += Input_Move;
            playerInput.actions.FindAction(move.name).canceled += Input_Move;
        }
    }
}