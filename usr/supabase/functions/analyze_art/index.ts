import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY');

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { image } = await req.json()
    if (!image) {
      throw new Error('Image base64 is required.')
    }

    if (!GEMINI_API_KEY) {
      throw new Error('GEMINI_API_KEY is not configured.')
    }

    // Call Gemini Pro Vision / 1.5 Pro
    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=${GEMINI_API_KEY}`
    
    const prompt = `You are an expert art historian specializing in 18th-century Constantine art and architecture.
Analyze the provided image and give a detailed written report with the following structure:
1. Stylistic Decomposition: Identify European influences (like Baroque curves) versus Local Constantine innovations (like specific geometric patterns, unique color palettes, local styling).
2. Botanical Identification: Carefully identify and name any plant or floral motifs present. Provide both their botanical (scientific) names and common names. Distinguish clearly between realistic representation and stylized local adaptation.`

    const body = {
      contents: [
        {
          parts: [
            { text: prompt },
            {
              inline_data: {
                mime_type: "image/jpeg",
                data: image
              }
            }
          ]
        }
      ]
    }

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });

    const data = await response.json()
    if (!response.ok) {
      throw new Error(data.error?.message || 'Failed to call Gemini API')
    }

    const report = data.candidates[0]?.content?.parts[0]?.text || "No analysis generated."

    return new Response(
      JSON.stringify({ report }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
    )
  }
})