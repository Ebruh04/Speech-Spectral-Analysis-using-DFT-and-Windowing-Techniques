🎙️ Speech Spectral Analysis using DFT & Windowing Techniques

This MATLAB project performs spectral analysis of real speech signals using DFT, FFT, STFT, windowing techniques, and PSD estimation. It explores how speech behaves in both time and frequency domains and demonstrates the effect of different window functions on spectral leakage and resolution.

🔍 Key Features
Audio loading and preprocessing (mono conversion + normalization)
Time-domain waveform visualization
Envelope extraction using Hilbert transform
Short-time energy analysis (voiced/unvoiced detection)
Window function comparison:
Rectangular
Hamming
Hann
Blackman
FFT-based magnitude spectrum with zero-padding
Spectrogram (STFT) analysis (2D & 3D views)
Power Spectral Density (PSD) using Welch’s method
📊 Tools & Concepts Used
MATLAB Signal Processing Toolbox
Discrete Fourier Transform (DFT / FFT)
Short-Time Fourier Transform (STFT)
Windowing techniques
Hilbert transform
Welch’s PSD estimation
Speech signal analysis fundamentals
🎯 Outcome

The project visualizes speech characteristics in both domains, showing:

Formant structures in voiced speech
Noise-like behavior in unvoiced regions
Energy concentration in the 0–4 kHz band
Trade-off between spectral resolution and leakage due to windowing
📂 Files Included
speech_analysis.m → Main MATLAB script
speech1.wav → Input speech signal 1
speech2.wav → Input speech signal 2
speech3.wav → Input speech signal 3
README.md → Project documentation
🚀 How to Run
Open MATLAB
Place all .wav files in the same folder as the script
Run:
speech_analysis
📌 Note

All plots are generated automatically, including:

Time-domain analysis
Window comparison spectra
Spectrograms
PSD plots
