% Assuming ScopeData1 is your variable in the workspace
time = ScopeData.GridCurrent.time;
signal = ScopeData.GridCurrent.signals.values(:, 1);  % Use the first dimension of the signal

% Parameters
start_time = 2.5;  % Start time in seconds
fundamental_frequency = 50;  % Fundamental frequency in Hz
max_frequency = 20000;  % Max frequency to consider in Hz

% Filter the data to start from the specified start time
filtered_indices = time >= start_time;
filtered_time = time(filtered_indices);
filtered_signal = signal(filtered_indices);

% Only consider the number of cycles specified
num_cycles = 1;
cycle_duration = num_cycles / fundamental_frequency;
end_time = start_time + cycle_duration;
cycle_indices = filtered_time <= end_time;

% Trim signal to the selected cycle duration
cycle_time = filtered_time(cycle_indices);
cycle_signal = filtered_signal(cycle_indices);

% Sampling frequency and signal length for the filtered data
Fs = 1 / (cycle_time(2) - cycle_time(1)); % Sampling frequency based on time steps
L = length(cycle_signal);                 % Length of filtered signal

% Remove any DC offset from the signal
cycle_signal = cycle_signal - mean(cycle_signal);

% Perform FFT
Y = fft(cycle_signal);
P2 = abs(Y/L);               % Two-sided amplitude spectrum
P1 = P2(1:floor(L/2)+1);     % Single-sided amplitude spectrum
P1(2:end-1) = 2 * P1(2:end-1);

% Frequency domain
f = Fs * (0:(L/2)) / L;

% Limit frequency range for plotting (up to max frequency)
f_indices = f <= max_frequency;
f = f(f_indices);
P1 = P1(f_indices);

% Calculate the RMS value at the fundamental frequency (50 Hz)
[~, fundamental_index] = min(abs(f - fundamental_frequency));  % Find index closest to 50 Hz
fundamental_amplitude = P1(fundamental_index);                 % Amplitude at the fundamental frequency
fundamental_rms = fundamental_amplitude / sqrt(2);             % Convert to RMS

% Display the RMS value at 50 Hz
fprintf('RMS Value at 50 Hz: %.2f\n', fundamental_rms);

% Calculate THD up to the Nyquist frequency
harmonics = P1(fundamental_index+1:end);  % Harmonics above the fundamental
THD = sqrt(sum(harmonics.^2)) / P1(fundamental_index) * 100;   % THD as a percentage

% Display THD
fprintf('Total Harmonic Distortion (THD): %.2f%%\n', THD);

% Plot single-sided amplitude spectrum
figure;
plot(f, P1) 
title('Single-Sided Amplitude Spectrum of Filtered X(t)')
xlabel('Frequency (Hz)')
ylabel('|P1(f)|')
