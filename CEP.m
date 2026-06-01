%% Speech Spectral Analysis using DFT and Windowing Techniques
clear all; 
close all; 
clc;

%% ====================================================================
%  SECTION 1: Signal Acquisition and Preprocessing
%  ====================================================================

fprintf('=== Speech Spectral Analysis Project ===\n\n');

% Load the three speech signals
% These are real speech recordings that will be analyzed
[speech1, fs1] = audioread('speech1.wav');
[speech2, fs2] = audioread('speech2.wav');
[speech3, fs3] = audioread('speech3.wav');

% Convert stereo to mono if necessary
% Speech analysis typically uses mono signals
if size(speech1, 2) > 1
    speech1 = mean(speech1, 2);  % Average left and right channels
end
if size(speech2, 2) > 1
    speech2 = mean(speech2, 2);
end
if size(speech3, 2) > 1
    speech3 = mean(speech3, 2);
end

% Normalize signals to [-1, 1] range
% This prevents amplitude variations from affecting spectral analysis
speech1 = speech1 / max(abs(speech1));
speech2 = speech2 / max(abs(speech2));
speech3 = speech3 / max(abs(speech3));

% Display signal information
fprintf('Signal Information:\n');
fprintf('  Speech 1: Duration = %.2f s, Sampling Rate = %d Hz\n', ...
    length(speech1)/fs1, fs1);
fprintf('  Speech 2: Duration = %.2f s, Sampling Rate = %d Hz\n', ...
    length(speech2)/fs2, fs2);
fprintf('  Speech 3: Duration = %.2f s, Sampling Rate = %d Hz\n\n', ...
    length(speech3)/fs3, fs3);

%% ====================================================================
%  SECTION 2: Time Domain Analysis
%  ====================================================================

% Create time vectors for plotting
t1 = (0:length(speech1)-1) / fs1;
t2 = (0:length(speech2)-1) / fs2;
t3 = (0:length(speech3)-1) / fs3;

% Figure 1: Time-domain waveforms and envelopes
figure('Name', 'Time Domain Analysis', 'Position', [100 100 1400 800]);

% Plot waveforms
subplot(3,3,1);
plot(t1, speech1, 'b', 'LineWidth', 0.8);
xlabel('Time (s)'); ylabel('Amplitude');
title('Speech 1 - Time Domain Waveform');
grid on; axis tight;

subplot(3,3,2);
plot(t2, speech2, 'r', 'LineWidth', 0.8);
xlabel('Time (s)'); ylabel('Amplitude');
title('Speech 2 - Time Domain Waveform');
grid on; axis tight;

subplot(3,3,3);
plot(t3, speech3, 'g', 'LineWidth', 0.8);
xlabel('Time (s)'); ylabel('Amplitude');
title('Speech 3 - Time Domain Waveform');
grid on; axis tight;

% Compute and plot signal envelopes using Hilbert transform
% The envelope shows the overall energy contour of the speech signal
env1 = abs(hilbert(speech1));
env2 = abs(hilbert(speech2));
env3 = abs(hilbert(speech3));

subplot(3,3,4);
plot(t1, speech1, 'b', 'LineWidth', 0.3); hold on;
plot(t1, env1, 'r', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Amplitude');
title('Speech 1 - Signal with Envelope');
legend('Signal', 'Envelope', 'Location', 'best');
grid on; axis tight;

subplot(3,3,5);
plot(t2, speech2, 'r', 'LineWidth', 0.3); hold on;
plot(t2, env2, 'b', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Amplitude');
title('Speech 2 - Signal with Envelope');
grid on; axis tight;

subplot(3,3,6);
plot(t3, speech3, 'g', 'LineWidth', 0.3); hold on;
plot(t3, env3, 'm', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Amplitude');
title('Speech 3 - Signal with Envelope');
grid on; axis tight;

% Compute short-time energy
% Energy helps identify voiced regions (high energy) vs. silence (low energy)
frame_size = round(0.02 * fs1);  % 20 ms frames
energy1 = sqrt(conv(speech1.^2, ones(frame_size,1)/frame_size, 'same'));
frame_size = round(0.02 * fs2);
energy2 = sqrt(conv(speech2.^2, ones(frame_size,1)/frame_size, 'same'));
frame_size = round(0.02 * fs3);
energy3 = sqrt(conv(speech3.^2, ones(frame_size,1)/frame_size, 'same'));

subplot(3,3,7);
plot(t1, energy1, 'b', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Energy');
title('Speech 1 - Short-Time Energy');
grid on; axis tight;

subplot(3,3,8);
plot(t2, energy2, 'r', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Energy');
title('Speech 2 - Short-Time Energy');
grid on; axis tight;

subplot(3,3,9);
plot(t3, energy3, 'g', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Energy');
title('Speech 3 - Short-Time Energy');
grid on; axis tight;

%% ====================================================================
%  SECTION 3: Window Function Analysis
%  ====================================================================

% Extract a representative frame from speech1 for window comparison
% We choose a frame from a high-energy region (likely voiced speech)
[~, peak_idx] = max(energy1);
frame_length = 512;  % Standard frame size
start_idx = max(1, peak_idx - frame_length/2);
end_idx = min(start_idx + frame_length - 1, length(speech1));
speech_frame = speech1(start_idx:end_idx);

% Pad if necessary to get exact frame_length
if length(speech_frame) < frame_length
    speech_frame = [speech_frame; zeros(frame_length - length(speech_frame), 1)];
end

% Define window functions
rect_win = rectwin(frame_length);        % Rectangular (no tapering)
hamm_win = hamming(frame_length);        % Hamming window
hann_win = hann(frame_length);           % Hann window
black_win = blackman(frame_length);      % Blackman window

% Figure 2: Window function comparison
figure('Name', 'Window Functions and Spectral Leakage', 'Position', [100 100 1400 900]);

% Plot window shapes
subplot(3,3,1);
plot(rect_win, 'k', 'LineWidth', 2); hold on;
plot(hamm_win, 'r', 'LineWidth', 2);
plot(hann_win, 'b', 'LineWidth', 2);
plot(black_win, 'g', 'LineWidth', 2);
xlabel('Sample'); ylabel('Amplitude');
title('Window Functions - Time Domain');
legend('Rectangular', 'Hamming', 'Hann', 'Blackman', 'Location', 'best');
grid on; ylim([0 1.1]);

% Apply windows to the speech frame
frame_rect = speech_frame .* rect_win;
frame_hamm = speech_frame .* hamm_win;
frame_hann = speech_frame .* hann_win;
frame_black = speech_frame .* black_win;

% Compute FFT with zero-padding for better frequency interpolation
N_fft = 2048;
FFT_rect = fft(frame_rect, N_fft);
FFT_hamm = fft(frame_hamm, N_fft);
FFT_hann = fft(frame_hann, N_fft);
FFT_black = fft(frame_black, N_fft);

% Extract magnitude spectrum (positive frequencies only)
freq_axis = (0:N_fft/2-1) * fs1 / N_fft;
mag_rect = 20*log10(abs(FFT_rect(1:N_fft/2)) + eps);  % Convert to dB
mag_hamm = 20*log10(abs(FFT_hamm(1:N_fft/2)) + eps);
mag_hann = 20*log10(abs(FFT_hann(1:N_fft/2)) + eps);
mag_black = 20*log10(abs(FFT_black(1:N_fft/2)) + eps);

% Plot windowed frames
subplot(3,3,2);
plot(frame_rect, 'k', 'LineWidth', 1);
xlabel('Sample'); ylabel('Amplitude');
title('Rectangular Windowed Frame');
grid on;

subplot(3,3,3);
plot(frame_hamm, 'r', 'LineWidth', 1);
xlabel('Sample'); ylabel('Amplitude');
title('Hamming Windowed Frame');
grid on;

% Plot individual spectra
subplot(3,3,4);
plot(freq_axis/1000, mag_rect, 'k', 'LineWidth', 1.5);
xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)');
title('Spectrum - Rectangular Window');
grid on; xlim([0 4]);

subplot(3,3,5);
plot(freq_axis/1000, mag_hamm, 'r', 'LineWidth', 1.5);
xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)');
title('Spectrum - Hamming Window');
grid on; xlim([0 4]);

subplot(3,3,6);
plot(freq_axis/1000, mag_hann, 'b', 'LineWidth', 1.5);
xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)');
title('Spectrum - Hann Window');
grid on; xlim([0 4]);

% Compare all windows together
subplot(3,3,7:9);
plot(freq_axis/1000, mag_rect, 'k', 'LineWidth', 1.5); hold on;
plot(freq_axis/1000, mag_hamm, 'r', 'LineWidth', 1.5);
plot(freq_axis/1000, mag_hann, 'b', 'LineWidth', 1.5);
plot(freq_axis/1000, mag_black, 'g', 'LineWidth', 1.5);
xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)');
title('Spectral Comparison - Effect of Different Windows');
legend('Rectangular', 'Hamming', 'Hann', 'Blackman', 'Location', 'best');
grid on; xlim([0 4]);

fprintf('Window Function Analysis:\n');
fprintf('  Rectangular: High spectral leakage, best frequency resolution\n');
fprintf('  Hamming: Good balance, -43dB sidelobe suppression\n');
fprintf('  Hann: Similar to Hamming, slightly narrower main lobe\n');
fprintf('  Blackman: Excellent sidelobe suppression (-58dB), wider main lobe\n\n');

%% ====================================================================
%  SECTION 4: Spectrogram Analysis (STFT)
%  ====================================================================

% Spectrogram parameters (consistent for all signals)
window_duration = 0.025;  % 25 ms frame length
overlap_duration = 0.015;  % 15 ms overlap (60%)

% Calculate frame parameters for each signal
win_length1 = round(window_duration * fs1);
overlap1 = round(overlap_duration * fs1);

win_length2 = round(window_duration * fs2);
overlap2 = round(overlap_duration * fs2);

win_length3 = round(window_duration * fs3);
overlap3 = round(overlap_duration * fs3);

% Figure 3: Spectrograms
figure('Name', 'Spectrogram Analysis (STFT)', 'Position', [100 100 1400 900]);

% Speech 1 - 2D Spectrogram
subplot(3,2,1);
spectrogram(speech1, hamming(win_length1), overlap1, 1024, fs1, 'yaxis');
title('Speech 1 - Spectrogram');
colorbar; ylim([0 4]);  % Focus on 0-4 kHz band

% Speech 1 - 3D View
subplot(3,2,2);
spectrogram(speech1, hamming(win_length1), overlap1, 1024, fs1, 'yaxis');
view(-45, 65);  % Adjust viewing angle
title('Speech 1 - 3D Spectrogram');
ylim([0 4000]);

% Speech 2 - 2D Spectrogram
subplot(3,2,3);
spectrogram(speech2, hamming(win_length2), overlap2, 1024, fs2, 'yaxis');
title('Speech 2 - Spectrogram');
colorbar; ylim([0 4]);

% Speech 2 - 3D View
subplot(3,2,4);
spectrogram(speech2, hamming(win_length2), overlap2, 1024, fs2, 'yaxis');
view(-45, 65);
title('Speech 2 - 3D Spectrogram');
ylim([0 4000]);

% Speech 3 - 2D Spectrogram
subplot(3,2,5);
spectrogram(speech3, hamming(win_length3), overlap3, 1024, fs3, 'yaxis');
title('Speech 3 - Spectrogram');
colorbar; ylim([0 4]);

% Speech 3 - 3D View
subplot(3,2,6);
spectrogram(speech3, hamming(win_length3), overlap3, 1024, fs3, 'yaxis');
view(-45, 65);
title('Speech 3 - 3D Spectrogram');
ylim([0 4000]);

%% ====================================================================
%  SECTION 5: Power Spectral Density Analysis
%  ====================================================================

% Figure 4: PSD Comparison
figure('Name', 'Power Spectral Density Analysis', 'Position', [100 100 1400 600]);

% Welch's method provides smooth PSD estimate with reduced variance
subplot(1,3,1);
pwelch(speech1, hamming(1024), 512, 2048, fs1);
title('Speech 1 - Power Spectral Density');
xlim([0 4000]); ylim([-80 20]);

subplot(1,3,2);
pwelch(speech2, hamming(1024), 512, 2048, fs2);
title('Speech 2 - Power Spectral Density');
xlim([0 4000]); ylim([-80 20]);

subplot(1,3,3);
pwelch(speech3, hamming(1024), 512, 2048, fs3);
title('Speech 3 - Power Spectral Density');
xlim([0 4000]); ylim([-80 20]);

%% ====================================================================
%  SECTION 6: Summary Report
%  ====================================================================

fprintf('========================================\n');
fprintf('SPECTRAL ANALYSIS SUMMARY\n');
fprintf('========================================\n\n');

fprintf('Analysis Parameters:\n');
fprintf('  Frame Length: %.1f ms\n', window_duration * 1000);
fprintf('  Frame Overlap: %.1f ms (%.0f%%)\n', overlap_duration * 1000, ...
    (overlap_duration/window_duration)*100);
fprintf('  Window Type: Hamming\n');
fprintf('  FFT Size: 1024/2048 points\n\n');

fprintf('Signal Characteristics:\n');
fprintf('  Speech 1: RMS = %.4f, Peak-to-RMS = %.2f dB\n', ...
    rms(speech1), peak2rms(speech1));
fprintf('  Speech 2: RMS = %.4f, Peak-to-RMS = %.2f dB\n', ...
    rms(speech2), peak2rms(speech2));
fprintf('  Speech 3: RMS = %.4f, Peak-to-RMS = %.2f dB\n\n', ...
    rms(speech3), peak2rms(speech3));

fprintf('Key Observations:\n');
fprintf('  - Spectrograms reveal formant structure in voiced regions\n');
fprintf('  - Harmonic patterns visible in periodic (voiced) segments\n');
fprintf('  - Unvoiced segments show noise-like, broadband spectrum\n');
fprintf('  - Main speech energy concentrated in 0-4 kHz band\n\n');

fprintf('========================================\n');
fprintf('Analysis Complete - All figures generated\n');
fprintf('Total Figures: 4\n');
fprintf('========================================\n');