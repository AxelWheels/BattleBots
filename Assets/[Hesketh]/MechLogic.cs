using UnityEngine;
using UnityEngine.InputSystem;

namespace BattleBots
{
    public class MechLogic : PawnLogic
    {
        [Header("Components")]
        [SerializeField] private PawnMovement pawnMovement = null;
        [SerializeField] private MechEjection mechEjection = null;

        [Header("Actions")]
        [SerializeField] private InputActionReference move = null;
        [SerializeField] private InputActionReference eject = null;

        protected override void DeregisterActions()
        {
            playerInput.actions.FindAction(move.name).performed -= Input_Move;
            playerInput.actions.FindAction(move.name).canceled -= Input_Move;

            playerInput.actions.FindAction(eject.name).performed -= Input_Eject;
        }

        protected override void RegisterActions()
        {
            playerInput.actions.FindAction(move.name).performed += Input_Move;
            playerInput.actions.FindAction(move.name).canceled += Input_Move;

            playerInput.actions.FindAction(eject.name).performed += Input_Eject;
        }

        /// <summary>
        /// A Vector2 value of the input joysticks x,y state
        /// Should be normalised before this point by the input system
        /// </summary>
        private void Input_Move(InputAction.CallbackContext context)
        {
            Vector2 input = context.ReadValue<Vector2>();
            pawnMovement.Direction = new Vector3(input.x, 0.0f, input.y);
        }

        /// <summary>
        /// Forcibly eject yourself from the mech
        /// </summary>
        private void Input_Eject(InputAction.CallbackContext context)
        {
            if (context.ReadValue<float>() >= 0.0f)
            {
                mechEjection.Eject();
            }
        }

    }
}