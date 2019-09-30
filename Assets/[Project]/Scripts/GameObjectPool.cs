using UnityEngine;

namespace BattleBots
{
    public class GameObjectPool : MonoBehaviour
    {
        [SerializeField] private GameObject targetPrefab = null;
        [SerializeField] private int poolSize = 0;

        private PooledObject[] pool = null;

        public GameObject Get()
        {
            for (int i = 0; i < pool.Length; i++)
            {
                if (pool[i].Available)
                {
                    pool[i].Available = false;
                    return pool[i].Target;
                }
            }

            Debug.LogError("<b>[GameObjectPool]</b> Pool Size for " + targetPrefab.name + " was insufficient!");
            return null;
        }

        public void Return(GameObject returnedObject)
        {
            for (int i = 0; i < pool.Length; i++)
            {
                if (pool[i].Target == returnedObject)
                {
                    pool[i].Available = true;
                    return;
                }
            }

            Debug.LogError("<b>[GameObjectPool]</b> Returned object " + returnedObject.name + " does not exist in the pool!");
        }

        protected virtual void Awake()
        {
            CreatePool();
        }

        private void CreatePool()
        {
            pool = new PooledObject[poolSize];
            for (int i = 0; i < poolSize; i++)
            {
                pool[i] = new PooledObject(Instantiate(targetPrefab, transform, true));
                ResetObject(ref pool[i]);
            }
        }

        private void ResetObject(ref PooledObject pooledObject)
        {
            pooledObject.Target.SetActive(false);
            pooledObject.Target.name = targetPrefab.name + " (Pooled by " + gameObject.name + ")";

            pooledObject.Transform.SetParent(transform);
            pooledObject.Transform.localPosition = Vector3.zero;
            pooledObject.Transform.localRotation = Quaternion.identity;
            pooledObject.Transform.localScale = Vector3.one;
        }
    }

    public struct PooledObject
    {
        public GameObject Target;
        public bool Available;

        public Transform Transform { get; private set; }

        public PooledObject(GameObject target)
        {
            Target = target;
            Transform = target.transform;
            Available = true;
        }
    }
}
