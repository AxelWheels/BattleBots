using UnityEngine;

[ExecuteInEditMode]
[RequireComponent( typeof( Camera ) )]
public class GlowPrePass : MonoBehaviour
{
	private static RenderTexture PrePass;
	private static RenderTexture Blurred;

	private Material m_BlurMat;

	void OnEnable()
	{
		PrePass = new RenderTexture( Screen.width, Screen.height, 24 );
		PrePass.antiAliasing = QualitySettings.antiAliasing;
		Blurred = new RenderTexture( Screen.width >> 1, Screen.height >> 1, 0 );

		Camera lCamera = GetComponent<Camera>();
		Shader lGlowShader = Shader.Find( "Hidden/GlowReplace" );
		lCamera.targetTexture = PrePass;
		lCamera.SetReplacementShader( lGlowShader, "Glowable" );
		Shader.SetGlobalTexture( "_GlowPrePassTex", PrePass );

		Shader.SetGlobalTexture( "_GlowBlurredTex", Blurred );

		m_BlurMat = new Material( Shader.Find( "Hidden/Blur" ) );
		m_BlurMat.SetVector( "_BlurSize", new Vector2( Blurred.texelSize.x * 1.5f, Blurred.texelSize.y * 1.5f ) );
	}

	void OnRenderImage( RenderTexture src, RenderTexture dst )
	{
		Graphics.Blit( src, dst );

		Graphics.SetRenderTarget( Blurred );
		GL.Clear( false, true, Color.clear );

		Graphics.Blit( src, Blurred );

		for( int i = 0; i < 4; i++ )
		{
			RenderTexture temp = RenderTexture.GetTemporary( Blurred.width, Blurred.height );
			Graphics.Blit( Blurred, temp, m_BlurMat, 0 );
			Graphics.Blit( temp, Blurred, m_BlurMat, 1 );
			RenderTexture.ReleaseTemporary( temp );
		}
	}
}
