using UnityEngine;
using UnityEngine.InputSystem.Plugins.PlayerInput;

namespace BattleBots
{
    public abstract class PawnLogic : MonoBehaviour
    {
        [SerializeField] public PlayerInput PlayerInput = null;

        [Header("Action Map")]
        [SerializeField] private string actionMapName = "";
        [SerializeField] private bool activateOnEnable = true;

        protected virtual void OnEnable()
        {
            if (!string.IsNullOrWhiteSpace(actionMapName) && activateOnEnable)
            {
                PlayerInput.SwitchCurrentActionMap(actionMapName);
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
