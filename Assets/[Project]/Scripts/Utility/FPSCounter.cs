using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class FPSCounter : MonoBehaviour
{
    [SerializeField]
    private Text text = null;

    [SerializeField]
    private float frequency = 0.5f;

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
            yield return new WaitForSeconds(frequency);
            float lTimeSpan = Time.realtimeSinceStartup - lLastTime;
            int lFrameCount = Time.frameCount - lLastFrameCount;

            // Display it
            FramesPerSecond = Mathf.RoundToInt(lFrameCount / lTimeSpan);
            text.text = FramesPerSecond.ToString() + " FPS";
        }
    }
}
