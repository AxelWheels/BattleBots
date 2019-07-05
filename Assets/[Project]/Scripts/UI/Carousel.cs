using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Carousel : MonoBehaviour
{
	[SerializeField] private List<GameObject> m_Items = new List<GameObject>();
	[SerializeField] private float m_currentIndex = 0;
	[SerializeField] private float m_Spacing = 20f;
	[SerializeField] private ScrollRect m_ScrollRect;

	private int m_NoOfItems = 0;
	private float m_normInc = 0f;
	private float m_LerpValue = 0f;

	public float CurrentIndex { get { return m_currentIndex; } }

	private void Awake()
	{
		m_NoOfItems = m_Items.Count;
		m_ScrollRect.horizontalNormalizedPosition = 0;
		m_normInc = 1f / ( m_NoOfItems - 1f );
	}

	// Use this for initialization
	void Start()
	{
	}

	// Update is called once per frame
	void Update()
	{
		m_ScrollRect.horizontalNormalizedPosition = Mathf.Lerp( m_ScrollRect.horizontalNormalizedPosition, m_LerpValue, Time.deltaTime * 10f );
	}

	public void NextItem()
	{
		m_currentIndex++;
		if( m_currentIndex > m_NoOfItems - 1 )
			m_currentIndex = 0;

		m_LerpValue = m_normInc * m_currentIndex;
	}

	public void PrevItem()
	{
		m_currentIndex--;
		if( m_currentIndex < 0 )
			m_currentIndex = m_NoOfItems - 1;

		m_LerpValue = m_normInc * m_currentIndex;
	}
}
