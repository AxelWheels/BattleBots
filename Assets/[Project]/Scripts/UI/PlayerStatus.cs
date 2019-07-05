using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerStatus : MonoBehaviour
{
	[SerializeField] private PlayerController m_PlayerInstance;

	[SerializeField] private RectTransform m_DodgeCooldown;
	[SerializeField] private RectTransform m_RangedCooldown;
	[SerializeField] private RectTransform m_HealthMask;
	[SerializeField] private RectTransform m_Lives;

	[SerializeField] private Image m_MechIcon;
	[SerializeField] private Image m_PilotIcon;
	[SerializeField] private Image m_HealthBar;
	[SerializeField] private Image m_Background;
	[SerializeField] private List<Image> m_LivesList = new List<Image>();

	[SerializeField] private GameObject m_LifeObject;

	[SerializeField] private Text m_HealthText;
	[SerializeField] private Text m_PlusMinusText;

	private float m_DodgeBarLength = 0f;
	private float m_RangedBarLength = 0f;
	private float m_HealthBarLength = 0f;
	private int m_PrevHealthVal = 100;

	public PlayerController PlayerInstance { set { m_PlayerInstance = value; } }
	public List<Image> LivesList { get { return m_LivesList; } set { m_LivesList = value; } }
	public Image MechIcon { get { return m_MechIcon; } set { m_MechIcon = value; } }
	public Image PilotIcon { get { return m_PilotIcon; } set { m_PilotIcon = value; } }
	public int PrevHealthVal { set { m_PrevHealthVal = value; } }

	// Use this for initialization
	void Start()
	{
		Color lBackgroundCol = m_PlayerInstance.PlayerColour.PColour;

		m_DodgeBarLength = m_DodgeCooldown.sizeDelta.y;
		m_RangedBarLength = m_RangedCooldown.sizeDelta.y;
		m_HealthBarLength = m_HealthMask.sizeDelta.x;
		m_HealthBar.color = lBackgroundCol;

		m_DodgeCooldown.GetComponent<Image>().color = lBackgroundCol;
		m_RangedCooldown.GetComponent<Image>().color = lBackgroundCol;
		//m_PlusMinusText.color = lBackgroundCol;

		lBackgroundCol.a = 0.6f;
		m_Background.color = lBackgroundCol;
	}

	void OnEnable()
	{
	}

	// Update is called once per frame
	void Update()
	{
		if( m_PlayerInstance != null )
		{
			CharacterInput lCInput = m_PlayerInstance.CharacterInput;

			//Search list of cooldowns to find ranged attack
			float lRangedCooldown = 0f;
			float lBombCooldown = 0f;

			foreach( Cooldown attack in lCInput.CooldownList )
			{
				if( attack.AttackType == eAttackType.Ranged )
				{
					lRangedCooldown = attack.TimeLeft;
				}
				if( attack.AttackType == eAttackType.BombPlot )
				{
					lBombCooldown = attack.TimeLeft;
				}
			}

			float lhealthValue;

			//Switches cooldowns being used if mech or pilot
			if( m_PlayerInstance.IsMech )
			{
				m_MechIcon.gameObject.SetActive( true );
				m_PilotIcon.gameObject.SetActive( false );
				lhealthValue = ( (float)m_PlayerInstance.CurrentHealth / (float)m_PlayerInstance.MechData.Health );
				m_DodgeCooldown.sizeDelta = new Vector2( m_DodgeCooldown.sizeDelta.x, m_DodgeBarLength * ( 1 - ( lCInput.MobilityCooldown / lCInput.InData.RocketBoostCooldown ) ) );
				m_RangedCooldown.sizeDelta = new Vector2( m_RangedCooldown.sizeDelta.x, m_RangedBarLength * ( 1 - ( lRangedCooldown / lCInput.InData.MechRangedCooldown ) ) );
			}
			else
			{
				m_MechIcon.gameObject.SetActive( false );
				m_PilotIcon.gameObject.SetActive( true );
				lhealthValue = ( (float)m_PlayerInstance.CurrentHealth / (float)m_PlayerInstance.PilotData.Health );
				m_DodgeCooldown.sizeDelta = new Vector2( m_DodgeCooldown.sizeDelta.x, m_DodgeBarLength * ( 1 - ( lCInput.MobilityCooldown / lCInput.InData.DodgeCooldown ) ) );
				m_RangedCooldown.sizeDelta = new Vector2( m_RangedCooldown.sizeDelta.x, m_RangedBarLength * ( 1 - ( lBombCooldown / lCInput.InData.PilotBombCooldown ) ) );
			}

			m_HealthMask.sizeDelta = new Vector2( lhealthValue * m_HealthBarLength, m_HealthMask.sizeDelta.y );
			m_PrevHealthVal = ( (int)Mathf.Lerp( m_PrevHealthVal, lhealthValue * 100, Time.deltaTime * 6f ) );
			m_HealthText.text = m_PrevHealthVal.ToString() + "%";
		}
	}

	public void PlayPlusMinusAnim( bool lPlus )
	{
		//Debug.Log( "PlusMinus" );
		m_PlusMinusText.text = lPlus ? "+1" : "-1";
		m_PlusMinusText.GetComponent<Animator>().SetTrigger( "Play" );
	}

	public void PlayHealthFlashAnim()
	{
		m_HealthText.GetComponent<Animator>().SetTrigger( "Play" );
	}

	public void SetupLivesUI()
	{
		if( !MatchController.Instance.GameModeData.UnlimitedLives )
		{
			for( int i = 0; i < MatchController.Instance.GameModeData.NumberOfLives; i++ )
			{
				GameObject lLife = Instantiate( m_LifeObject, m_Lives );
				m_LivesList.Add( lLife.GetComponent<Image>() );
				lLife.SetActive( true );
			}
		}
	}

	public void ResetLivesUI()
	{
		//Debug.Log( LivesList.Count );
		for( int i = 0; i < LivesList.Count; i++ )
		{
			Destroy( LivesList[i].gameObject );
		}
		LivesList.Clear();
	}
}
