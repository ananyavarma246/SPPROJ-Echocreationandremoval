[x, fs] = audioread("hindi_2s.wav");
[Xe, fs1] = audioread("hindi.wav");

% sound(x, fs);
% pause(length(x)/fs + 0.1);

[filtered_signal, error_signal] = nlms(x, Xe, 128, fs1);

sound(filtered_signal, fs1);
% pause(length(filtered_signal)/fs1 + 0.1);

figure;
subplot(3,1,1);
plot(x);
title('Original Signal');

subplot(3,1,2);
plot(filtered_signal);
title('Filtered Signal');

subplot(3,1,3);
plot(error_signal);
title('Error Signal');

function [filtered_signal, error_signal] = nlms(x, di, sysorder, fs)
    N = length(x);
    b = fir1(sysorder - 1, 0.5);
    e = filter(b, 1, di);
    n = 0.01 * randn(length(e), 1);
    d = e + n;
    w = zeros(sysorder, 1);

    [filtered_signal, error_signal] = nlmsAlgorithm(x, d, w, sysorder, N);
end

function [filtered_signal, error_signal] = nlmsAlgorithm(x, d, w, sysorder, N)
    filtered_signal = zeros(N, 1);
    error_signal = zeros(N, 1);

    for n = sysorder:N
        u = x(n:-1:n - sysorder + 1);
        y = w' * u;
        error_signal(n) = d(n) - y;
        mu = 0.5 / (1 + u' * u);
        w = w + mu * u * error_signal(n);
        filtered_signal(n) = y;
    end
end
