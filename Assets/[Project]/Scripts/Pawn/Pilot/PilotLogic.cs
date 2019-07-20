using System;
using UnityEngine;
using UnityEngine.InputSystem;

namespace BattleBots
{
    public class PilotLogic : PawnLogic
    {
        [Header("Components")]
        [SerializeField] private PawnMovement pawnMovement = null;

        [Header("Actions")]
        [SerializeField] private InputActionReference move = null;
        [SerializeField] private InputActionReference shoot = null;

        /// <summary>
        /// A Vector2 value of the input joysticks x,y state
        /// Should be normalised before this point by the input system
        /// </summary>
        public void Input_Move(InputAction.CallbackContext context)
        {
            Vector2 input = context.ReadValue<Vector2>();
            pawnMovement.Direction = new Vector3(input.x, 0.0f, input.y);
        }

        /// <summary>
        /// A value of 1 (true) and 0 (false) whether the shoot input action is fired
        /// </summary>
        public void Input_Shoot(InputAction.CallbackContext context)
        {
            throw new NotImplementedException();
        }

        protected override void DeregisterActions()
        {
            playerInput.actions.FindAction(move.name).performed -= Input_Move;
            playerInput.actions.FindAction(move.name).canceled -= Input_Move;

            playerInput.actions.FindAction(shoot.name).performed += Input_Shoot;
        }

        protected override void RegisterActions()
        {
            playerInput.actions.FindAction(move.name).performed += Input_Move;
            playerInput.actions.FindAction(move.name).canceled += Input_Move;

            playerInput.actions.FindAction(shoot.name).performed -= Input_Shoot;
        }
    }
}