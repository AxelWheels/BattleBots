using UnityEngine;
using System;

/// <summary>
/// Pre-Instantiates an amount of a given type of Prefab and reuses them
/// Ensures we dont have to overwork Garbage Collection if we re-use the pooled object type frequently
/// </summary>
public class GameObjectPool : MonoBehaviour
{
    [SerializeField] private GameObject targetPrefab = null;
    [SerializeField] private int poolSize = 0;

    private PooledObject[] pool = null;

    /// <summary>
    /// Returns the next available game object from within the object pool
    /// The GameObject will be inactive, and at the pool's position.
    /// When wanting to destroy the game object it should instead be <see cref="Return(GameObject)"/>ed
    /// </summary>
    /// <returns>The GameObject for use as usual</returns>
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

        throw new Exception("Insufficient pool size. It is currently " + poolSize.ToString());
    }

    /// <summary>
    /// Instructs the object pool that the given object can be made re-available for other requests
    /// </summary>
    /// <param name="returnedObject">The object retrieved from the pool that is being returned</param>
    public void Return(GameObject returnedObject)
    {
        for (int i = 0; i < pool.Length; i++)
        {
            if (pool[i].Target == returnedObject)
            {
                pool[i].Available = true;
                ResetObject(ref pool[i]);
                return;
            }
        }

        throw new Exception("Provided object does not persist within this object pool");
    }

    /// <summary>
    /// Instantiate all of the objects once the game starts
    /// </summary>
    protected virtual void Awake()
    {
        CreatePool();
    }

    /// <summary>
    /// Instantiates <see cref="poolSize"/> amount of the prefab <see cref="targetPrefab"/>
    /// </summary>
    private void CreatePool()
    {
        pool = new PooledObject[poolSize];
        for (int i = 0; i < poolSize; i++)
        {
            pool[i] = new PooledObject(Instantiate(targetPrefab, transform, true));
            ResetObject(ref pool[i]);
        }
    }

    /// <summary>
    /// Sets the instantiated object to be at the expected position and active state
    /// </summary>
    /// <param name="pooledObject"></param>
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

/// <summary>
/// The structure of the container for a PooledObject
/// </summary>
public struct PooledObject
{
    public GameObject Target;
    public bool Available;

    /// <summary>
    /// Cache of the Transfrom to imporve efficiency in accessing transformation functions
    /// </summary>
    public Transform Transform { get; private set; }

    public PooledObject(GameObject target)
    {
        Target = target;
        Transform = target.transform;
        Available = true;
    }
}
