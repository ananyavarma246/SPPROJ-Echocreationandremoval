%% original signal is x[n].
%% taking the echoed signal to be y[n]
%% since echoed signal is the sum of the orignal and the delayed signal:::
%% echoed signal is y[n] = x[n] + alpha * x[n-N0]
%% alpha : attenuation parameter (0,1) , and N0 : no. of samples in delayed time period

%% finding the signal from the wav file
[x, Fs] = audioread("hindi_2s.wav");
d = 30;
% delay = 2 * d / 330;
delay = 0.6;
N0 = ceil(delay * Fs);
% hence the impulse response of the system is h[n] = del[n] + alpha * del[n-N0]
h = zeros(1,N0+1);
time_index_echoed_signal = 0 : 1/Fs : (length(h)-1)/Fs;
% giving sample weights to the impulse response
alpha = 0.6;
h(1) = 1;
h(N0+1) = alpha;

y = conv(x(:,1),h,"full");
time_of_y =  length(y)/Fs;
% disp(time_of_y);
% disp(length(y));
% display(time_of_y);
 attack = 1000;
 decay = 100000;
 release = 400000;
 sustain = 0.7;
 sustain_duration = length(y)-(attack+decay+release);

env = envelope(attack,decay,0.7,sustain_duration,release);
disp(length(env));
disp(length(y));
time_convoluted_signal = 0 : 1/Fs : (length(y)-1)/Fs;
 % final_echoed_signal = y .*env;

% for k = 1 : length(y)
%     y(k) = y(k) * env(k);
% end

figure;
subplot(3,1,1);
plot((0 : 1 : length(x(:, 1))-1)/Fs, x, 'Color','r');
xlabel("time");
ylabel("x[n]");
title("ORIGINAL SIGNAL");
% xlim([0,10000/Fs]);
sound(x,Fs);
pause((length(x)/Fs));

subplot(3,1,2);
stem(time_index_echoed_signal, h, "filled",'Color','b');
xlabel("time corresponding to the samples");
ylabel("h[n]");
title("IMPULSE RESPONSE");

subplot(3,1,3);
plot(time_convoluted_signal,y,'Color','r');
xlabel("time");
ylabel("y[n]");
title("ECHOED SIGNAL");
% xlim([0,10000/Fs]);

sound(y,Fs);


function env = envelope(a,d,s,sd,r)
t_total = a+d+sd+r;
sample_indices = 0 : 1 : t_total-1;
% t_env = 0 : 1/fs : t_total-1/fs;
% t_env = [t_env, a+d+sd+r];
env = zeros(size(sample_indices));
 % attack
 for k = 1 : length(sample_indices)
     if(sample_indices(k)<=a)
         env(k) = sample_indices(k)/a;
     end

     if(sample_indices(k)>=a && sample_indices(k)<=a+d)
         env(k) = 1 + ((s-1)/d)* (sample_indices(k) - a);
     end

     if(sample_indices(k)>=a+d && sample_indices(k)<=a+d+sd)
         env(k) = s;
     end

     if(sample_indices(k)>=a+d+sd  &&  sample_indices(k)<=a+d+sd+r)
         env(k) = -1 * (s/r) * (sample_indices(k) - a-d-sd-r);
     end
 end
end
