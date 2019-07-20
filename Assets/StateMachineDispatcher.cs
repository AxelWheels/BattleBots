using UnityEngine;

namespace BattleBots
{
    public class StateMachineDispatcher : StateMachineBehaviour
    {
        [Header("Dispatch States")]
        [SerializeField] private bool enter = true;
        [SerializeField] private bool update = true;
        [SerializeField] private bool exit = true;

        private IOnStateEnter[] enterListeners = new IOnStateEnter[0];
        private IOnStateUpdate[] updateListener = new IOnStateUpdate[0];
        private IOnStateExit[] exitListener = new IOnStateExit[0];

        private bool fetched = false;

        //OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
        public override void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            if (!fetched)
            {
                FetchListeners(animator);
            }

            if (enter)
            {
                for (int i = 0; i < enterListeners.Length; i++)
                {
                    enterListeners[i].OnStateEnter(animator, stateInfo, layerIndex);
                }
            }
        }

        //OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
        public override void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            if (!fetched)
            {
                FetchListeners(animator);
            }

            if (update)
            {
                for (int i = 0; i < updateListener.Length; i++)
                {
                    updateListener[i].OnStateUpdate(animator, stateInfo, layerIndex);
                }
            }
        }

        //OnStateExit is called when a transition ends and the state machine finishes evaluating this state
        public override void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
        {
            if (!fetched)
            {
                FetchListeners(animator);
            }

            if (exit)
            {
                for (int i = 0; i < exitListener.Length; i++)
                {
                    exitListener[i].OnStateExit(animator, stateInfo, layerIndex);
                }
            }
        }

        private void FetchListeners(Animator animator)
        {
            fetched = true;

            if (enter)
            {
                enterListeners = animator.GetComponents<IOnStateEnter>();
            }

            if (update)
            {
                updateListener = animator.GetComponents<IOnStateUpdate>();
            }

            if (exit)
            {
                exitListener = animator.GetComponents<IOnStateExit>();
            }
        }
    }

    public interface IOnStateEnter
    {
        void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex);
    }

    public interface IOnStateUpdate
    {
        void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex);
    }

    public interface IOnStateExit
    {
        void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex);
    }

}