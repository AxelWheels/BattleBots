using UnityEngine;

namespace BattleBots
{
    [RequireComponent(typeof(PawnLogic))]
    public class MechEjection : MonoBehaviour, IOnStateUpdate
    {
        [Header("Components")]
        [SerializeField] private Animator animator = null;
        [SerializeField] private string ejectTriggerParam = "MechReturn";
        [SerializeField] private float ejectNormalizedTime = 0.4f;

        [Header("Transforms")]
        [SerializeField] private Transform pilot = null;
        [SerializeField] private Transform pilotEjectionLocation = null;

        //[Header("Properties")]
        //[SerializeField] private float ejectionForce = 200.0f;

        [SerializeField, HideInInspector] private int ejectTriggerParamHash = -1;
        private bool ejecting = false;

        public void Eject()
        {
            animator.SetTrigger(ejectTriggerParam);
            ejecting = true;
        }

        public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            if (ejecting && ejectTriggerParamHash == stateInfo.shortNameHash)
            {
                if (stateInfo.normalizedTime >= ejectNormalizedTime)
                {
                    EjectPilot();
                    ejecting = false;
                }
            }
        }

        protected virtual void OnValidate()
        {
            ejectTriggerParamHash = Animator.StringToHash(ejectTriggerParam);
        }

        private void EjectPilot()
        {
            // TODO: Implement proper ejection procedure
            pilot.position = pilotEjectionLocation.position;
            pilot.rotation = pilotEjectionLocation.rotation;
            pilot.gameObject.SetActive(true);

            // Temporary animation disable
            GetComponent<Animator>().speed = 0.0f; 
        }
    }
}