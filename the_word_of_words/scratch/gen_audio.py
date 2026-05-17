"""
Generate minimal WAV audio files for the game SFX.
These replace the empty placeholder files.
"""
import struct
import math
import os

def write_wav(filename, frequency, duration, volume=0.5, sample_rate=22050):
    """Write a simple sine-wave tone as a WAV file."""
    num_samples = int(sample_rate * duration)
    
    # WAV header
    data_size = num_samples * 2  # 16-bit samples
    header = struct.pack('<4sI4s4sIHHIIHH4sI',
        b'RIFF',
        36 + data_size,
        b'WAVE',
        b'fmt ',
        16,           # PCM chunk size
        1,            # PCM format
        1,            # Mono
        sample_rate,
        sample_rate * 2,  # byte rate
        2,            # block align
        16,           # bits per sample
        b'data',
        data_size,
    )
    
    samples = []
    for i in range(num_samples):
        t = i / sample_rate
        # Fade out envelope
        envelope = max(0, 1 - (t / duration) ** 0.5)
        val = int(volume * envelope * 32767 * math.sin(2 * math.pi * frequency * t))
        samples.append(struct.pack('<h', val))
    
    with open(filename, 'wb') as f:
        f.write(header)
        f.write(b''.join(samples))
    
    print(f"Generated {filename} ({os.path.getsize(filename)} bytes)")

def write_chord_wav(filename, frequencies, duration, volume=0.4, sample_rate=22050):
    """Write a chord (multiple frequencies) as WAV."""
    num_samples = int(sample_rate * duration)
    data_size = num_samples * 2
    header = struct.pack('<4sI4s4sIHHIIHH4sI',
        b'RIFF', 36 + data_size, b'WAVE',
        b'fmt ', 16, 1, 1, sample_rate, sample_rate * 2, 2, 16,
        b'data', data_size,
    )
    samples = []
    for i in range(num_samples):
        t = i / sample_rate
        envelope = max(0, 1 - (t / duration) ** 0.7)
        val = 0
        for freq in frequencies:
            val += math.sin(2 * math.pi * freq * t)
        val = int((volume / len(frequencies)) * envelope * 32767 * val)
        val = max(-32767, min(32767, val))
        samples.append(struct.pack('<h', val))
    with open(filename, 'wb') as f:
        f.write(header)
        f.write(b''.join(samples))
    print(f"Generated {filename} ({os.path.getsize(filename)} bytes)")

audio_dir = r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\audio'

# correct.wav — happy ascending chord (C-E-G)
write_chord_wav(
    os.path.join(audio_dir, 'correct.wav'),
    frequencies=[523, 659, 784],  # C5, E5, G5
    duration=0.6,
    volume=0.5,
)

# wrong.wav — low dull thud
write_wav(
    os.path.join(audio_dir, 'wrong.wav'),
    frequency=180,
    duration=0.3,
    volume=0.4,
)

# click.wav — short high tick
write_wav(
    os.path.join(audio_dir, 'click.wav'),
    frequency=1200,
    duration=0.08,
    volume=0.3,
)

# pop.wav — mid pop
write_wav(
    os.path.join(audio_dir, 'pop.wav'),
    frequency=600,
    duration=0.1,
    volume=0.35,
)

# home_bg.wav — gentle hum (background music placeholder)
write_wav(
    os.path.join(audio_dir, 'home_bg.wav'),
    frequency=220,
    duration=2.0,
    volume=0.15,
)

print("\nDone! All audio files generated.")
