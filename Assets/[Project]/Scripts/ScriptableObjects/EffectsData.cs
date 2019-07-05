using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu( fileName = "EffectsData.asset", menuName = "Onyx/Create EffectsData Object", order = 0 )]
public class EffectsData : ScriptableObject
{
	[SerializeField]
	private List<EffectObjectData> m_EffectsToPool;

	public List<EffectObjectData> Objects { get { return m_EffectsToPool; } }
}
