import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY');

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { prompt } = await req.json()
    if (!prompt) {
      throw new Error('Analysis prompt is required.')
    }

    if (!OPENAI_API_KEY) {
      throw new Error('OPENAI_API_KEY is not configured.')
    }

    const imageGenerationPrompt = `Based on the following art analysis, create a new high-quality stylized image showcasing ONLY the local Constantine innovations and botanical patterns described. Completely exclude any European influences (e.g., Baroque curves). The style should reflect pure local 18th-century Constantine art aesthetics.\n\nAnalysis context:\n${prompt.substring(0, 800)}...`

    const response = await fetch('https://api.openai.com/v1/images/generations', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${OPENAI_API_KEY}`
      },
      body: JSON.stringify({
        model: "dall-e-3",
        prompt: imageGenerationPrompt,
        n: 1,
        size: "1024x1024"
      }),
    })

    const data = await response.json()
    if (!response.ok) {
      throw new Error(data.error?.message || 'Failed to generate image')
    }

    const imageUrl = data.data[0]?.url

    return new Response(
      JSON.stringify({ imageUrl }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
    )
  }
})