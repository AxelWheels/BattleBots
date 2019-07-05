using UnityEngine;
using System.Collections;
using Cinemachine;

public class CameraShake : SingletonManager<CameraShake>
{
	[SerializeField]
	private CinemachineVirtualCamera m_VirtualCamera;

	private CinemachineBasicMultiChannelPerlin m_NoiseModule;

	private void Update()
	{
		if (Input.GetKeyDown(KeyCode.Space))
		{
			Shake( 0.05f, 100, 0.15f );
		}
	}

	public void Shake( float lAmplitude, float lMagnitude, float lDuration )
	{
		if (m_NoiseModule == null)
		{
			m_NoiseModule = m_VirtualCamera.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
		}

		if( m_NoiseModule != null )
		{
			m_NoiseModule.m_FrequencyGain = lMagnitude;
			m_NoiseModule.m_AmplitudeGain = lAmplitude;

			Invoke( "StopShaking", lDuration );
		}
	}

	public void StopShaking()
	{
		m_NoiseModule.m_FrequencyGain = 0;
		m_NoiseModule.m_AmplitudeGain = 0;
	}
}
