using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class FPSCounter : MonoBehaviour
{
    [SerializeField]
    private Text m_Text;

    [SerializeField]
    private float m_Frequency = 0.5f;

    public int FramesPerSecond { get; protected set; }

    private void Start()
    {
        StartCoroutine(MeasureFPS());
    }

    private IEnumerator MeasureFPS()
    {
        for (; ; )
        {
            // Capture frame-per-second
            int lLastFrameCount = Time.frameCount;
            float lLastTime = Time.realtimeSinceStartup;
            yield return new WaitForSeconds(m_Frequency);
            float lTimeSpan = Time.realtimeSinceStartup - lLastTime;
            int lFrameCount = Time.frameCount - lLastFrameCount;

            // Display it
            FramesPerSecond = Mathf.RoundToInt(lFrameCount / lTimeSpan);
            m_Text.text = FramesPerSecond.ToString() + " FPS";
        }
    }
}
