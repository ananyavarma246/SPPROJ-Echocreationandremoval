%% FFT's of the given noise files
[music_water_pump,Fs_water] = audioread("music_water-pump.wav");
[music_pressure_cooker, Fs_cooker] = audioread("music_pressure-cooker.wav");
[music_city_traffic,Fs_traffic] = audioread("music_city-traffic.wav");
[music_ceiling_fan,Fs_fan] = audioread("music_ceiling-fan.wav");

[music_ceiling_fan_test,Fs_fan_test] = audioread("music_ceiling-fan_hp.wav");
[music_city_traffic_test, Fs_traffic_test] = audioread("music_city-traffic_hp.wav");
[music_pressure_cooker_test, Fs_cooker_test] = audioread("music_pressure-cooker_hp.wav");
[music_water_pump_test, Fs_water_test] = audioread("music_water-pump_hp.wav");

figure;
mixed_signal = [music_pressure_cooker_test;music_ceiling_fan_test;music_city_traffic_test];
subplot(5,1,1);
plot(mixed_signal,'Color','b');

[mixed_resenmble_ceiling_fan,lag1] = xcorr(mixed_signal,music_ceiling_fan,Fs_fan);
subplot(5,1,2);
plot(mixed_resenmble_ceiling_fan,'Color','b');


[mixed_resenmble_water_pump, lag2] = xcorr(mixed_signal, music_water_pump,Fs_traffic);
subplot(5,1,3);
plot(mixed_resenmble_water_pump,'Color','b');

[mixed_resenmble_traffic,lag3] = xcorr(mixed_signal,music_city_traffic,Fs_cooker);
subplot(5,1,4);
plot(mixed_resenmble_traffic,'Color','b');

[mixed_resenmble_cooker,lag4] = xcorr(mixed_signal, music_pressure_cooker,Fs_water);
subplot(5,1,5);
plot(mixed_resenmble_cooker,'Color','b');

