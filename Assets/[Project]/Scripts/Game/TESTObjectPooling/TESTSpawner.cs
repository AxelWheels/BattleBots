using UnityEngine;

public class TESTSpawner : MonoBehaviour
{

	public float timeBetweenSpawns;

	public PooledObject[] stuffPrefabs;

	float timeSinceLastSpawn;

	void FixedUpdate()
	{
		timeSinceLastSpawn += Time.deltaTime;
		if( timeSinceLastSpawn >= timeBetweenSpawns )
		{
			timeSinceLastSpawn -= timeBetweenSpawns;
			SpawnStuff();
		}
	}

	void SpawnStuff()
	{
		//TESTSpawnable prefab = stuffPrefabs[Random.Range( 0, stuffPrefabs.Length )];
		//USE THIS METHOD for object pooling.
		PooledObject spawn = stuffPrefabs[Random.Range( 0, stuffPrefabs.Length )].GetPooledInstance<PooledObject>();
		spawn.ReturnToPool( 1.0f );
		//TESTSpawnable spawn = (TESTSpawnable)EffectsController.Instance.Pools[prefab.name].GetObject();
		spawn.transform.localPosition = transform.position;
	}
}