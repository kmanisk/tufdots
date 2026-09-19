// Minimal local ReShade.fxh for personal vkBasalt use.
// Provides the COLOR-semantic BackBuffer binding (which vkBasalt wires to
// the live frame) plus the standard fullscreen-triangle PostProcessVS.
// NOTE: texture and sampler must have DIFFERENT names here; vkBasalt's
// compiler rejects upstream's same-name idiom as a redefinition.
// (Upstream ReShade ships the full file with its installer.)
#pragma once

namespace ReShade
{
	// vkBasalt binds the frame to any texture carrying the COLOR semantic
	// (see effect_reshade.cpp). The texture and sampler must have DIFFERENT
	// names here: vkBasalt's compiler rejects the upstream same-name idiom
	// as a redefinition. Vibrance.fx itself stays pristine.
	texture BackBufferTex : COLOR;
	sampler BackBuffer
	{
		Texture = BackBufferTex;
	};
}

void PostProcessVS(in uint id : SV_VertexID, out float4 position : SV_Position, out float2 texcoord : TEXCOORD)
{
	texcoord = float2((id << 1) & 2, id & 2);
	position = float4(texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
}
