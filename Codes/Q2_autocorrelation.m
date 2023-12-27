%% echoed signal 
[x_echoed, Fs]= audioread("q2_easy.wav");
figure;

subplot(4,1,1);
plot(x_echoed,'Color','r');
xlabel('time');
ylabel("x[n]");
title("ECHOED SIGNAL");
sound(x_echoed,Fs);
% pause(length(x_echoed)/Fs);

[y,lag] = xcorr(x_echoed(:,1),x_echoed(:,1),'normalized');
y_temp = y;
y_correlated= y;
y_temp_for_delays_indicex = zeros(1, length(y_temp));
subplot(4,1,2);
plot(lag,y);
length_local_max = 2;
while(length_local_max > 1)
    y_previous = y;
    local_max_points = islocalmax(y);
    y = y.*local_max_points;
    local_max_points(local_max_points==0) = [];
    y(y==0) = [];
    length_local_max = length(y);
end
local_max_indices_final = zeros(1, length(y_previous));
for k = 1 : length(y_previous)
    samples_check_for_index = y_previous(k);
    for m = 1 : length(y_temp)
        if(y_temp(m) == samples_check_for_index)
            y_temp_for_delays_indicex(m) = samples_check_for_index;
            y_temp(m)=0;
            local_max_indices_final(k) = m;
            break;
        end
        
    end
end

subplot(4,1,3);
stem(lag,y_temp_for_delays_indicex,"filled",'Color','b');
xlabel('time');
ylabel('peaks of autocorrelation');
title("PEAKS CORRESPONDING TO THE ECHOS");


%% delaying the correlated sigal and subtracting the echos
%% 
% after delaying the correlated signal we divide the corresponding samples
% the minimum of the divided values will be the attenuation factor for the
% corresponding echo

attenuations = zeros(1, length(local_max_indices_final));
for k = 1 : length(local_max_indices_final)
    delay = local_max_indices_final(k);
    component_to_be_delayed = zeros(1, delay);
    for m = 1 : delay
        component_to_be_delayed(m) = y_correlated(m);
    end
    delayed_signal = zeros(1, 2*delay-1);
    for l = delay : length(delayed_signal)
        delayed_signal(l) = component_to_be_delayed(l-delay+1);
    end

    Corresponding_division_array = zeros(1, delay);
    for n = 1 : delay
        if((n+delay-1) <= length(y_correlated))
        Corresponding_division_array(n) = y_correlated(n+delay-1)/delayed_signal(n+delay-1);
        if(Corresponding_division_array(n)<1)
            attenuations(k) = Corresponding_division_array(n);
            break;
        end
        end
    end
    % if(min(Corresponding_division_array)<=1)
        % attenuations(k) = min(Corresponding_division_array);
    % end
end
disp(attenuations);
%% impulse response
% numerator
% h = zeros(1, length(x_echoed));
num = zeros(1, length(x_echoed));
num(1) = 1;
for k = 1 : length(local_max_indices_final)
    delay = local_max_indices_final(k);
    num(local_max_indices_final(k))=delay;
end
den = 1;
audio_without_echo = filter(den,num,x_echoed);
subplot(4,1,4);
plot(audio_without_echo);
sound(audio_without_echo);




