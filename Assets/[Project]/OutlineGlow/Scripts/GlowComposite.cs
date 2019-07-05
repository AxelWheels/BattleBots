using UnityEngine;

[ExecuteInEditMode]
[RequireComponent( typeof( Camera ) )]
public class GlowComposite : MonoBehaviour
{
	[SerializeField, Range( 0, 10 )]
	private float Intensity = 2;

	private Material m_CompositeMaterial;

	void OnEnable()
	{
		m_CompositeMaterial = new Material( Shader.Find( "Hidden/GlowComposite" ) );
	}

	void OnRenderImage( RenderTexture lSource, RenderTexture lDestination )
	{
		m_CompositeMaterial.SetFloat( "_Intensity", Intensity );
		Graphics.Blit( lSource, lDestination, m_CompositeMaterial, 0 );
	}
}
