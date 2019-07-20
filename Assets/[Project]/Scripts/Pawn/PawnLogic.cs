using UnityEngine;
using UnityEngine.InputSystem.Plugins.PlayerInput;

namespace BattleBots
{
    public abstract class PawnLogic : MonoBehaviour
    {
        [Header("Action Map")]
        [SerializeField] private string actionMapName = "";
        [SerializeField] private bool activateOnEnable = true;

        protected PlayerInput playerInput = null;

        protected virtual void Awake()
        {
            playerInput = GetComponentInParent<PlayerInput>();
        }

        protected virtual void OnEnable()
        {
            if (!string.IsNullOrWhiteSpace(actionMapName) && activateOnEnable)
            {
                playerInput.SwitchCurrentActionMap(actionMapName);
            }

            RegisterActions();
        }

        protected virtual void OnDisable()
        {
            DeregisterActions();
        }

        protected abstract void RegisterActions();
        protected abstract void DeregisterActions();
    }
}
