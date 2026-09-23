-- Enable pgcrypto for UUIDs
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- USERS TABLE (Linked to auth.users)
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT NOT NULL,
    phone TEXT,
    public_key TEXT NOT NULL,
    fingerprint TEXT NOT NULL,
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- RLS for users
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users are viewable by everyone" 
ON public.users FOR SELECT 
USING (true);

CREATE POLICY "Users can insert their own profile" 
ON public.users FOR INSERT 
WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile" 
ON public.users FOR UPDATE 
USING (auth.uid() = id);

-- MESSAGES TABLE (for cloud relay)
CREATE TABLE public.messages (
    id TEXT PRIMARY KEY, -- Using client-generated uuid
    conversation_id TEXT NOT NULL,
    sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    recipient_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    sender_name TEXT NOT NULL,
    content TEXT NOT NULL,
    encrypted_payload TEXT,
    nonce TEXT,
    payload_hash TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    ttl INT DEFAULT 8 NOT NULL,
    hop_count INT DEFAULT 0 NOT NULL,
    status TEXT NOT NULL,
    transport TEXT NOT NULL,
    relay_path JSONB DEFAULT '[]'::jsonb,
    media_type TEXT DEFAULT 'text' NOT NULL,
    media_url TEXT,
    audio_duration_seconds INT,
    reply_to_message_id TEXT
);

-- RLS for messages
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own messages"
ON public.messages FOR SELECT
USING (auth.uid() = sender_id OR auth.uid() = recipient_id);

CREATE POLICY "Users can insert messages they send"
ON public.messages FOR INSERT
WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Users can update status of messages they receive"
ON public.messages FOR UPDATE
USING (auth.uid() = recipient_id);

-- Enable Realtime for messages table
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
