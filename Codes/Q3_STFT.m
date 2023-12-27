function main()
    inputAudioFile = "music_ceiling-fan_hp.wav";
    detectedNoiseType = classifyNoise(inputAudioFile);
    disp('The detected noise type is: ' + detectedNoiseType);

    [ceilingFanAmplitude, ceilingFanFrequency] = processAudioFile("music_ceiling-fan_hp.wav");
    plotSignal(ceilingFanFrequency, ceilingFanAmplitude, "Ceiling Fan");

    [trafficAmplitude, trafficFrequency] = processAudioFile("music_city-traffic_hp.wav");
    plotSignal(trafficFrequency, trafficAmplitude, "Traffic");

    [pressureCookerAmplitude, pressureCookerFrequency] = processAudioFile("music_pressure-cooker_hp.wav");
    plotSignal(pressureCookerFrequency, pressureCookerAmplitude, "Pressure Cooker");

    [waterPumpAmplitude, waterPumpFrequency] = processAudioFile("music_water-pump_hp.wav");
    plotSignal(waterPumpFrequency, waterPumpAmplitude, "Water Pump");

    [inputAmplitude, inputFrequency] = processAudioFile(inputAudioFile);
    plotSignal(inputFrequency, inputAmplitude, "Input");
end

function plotSignal(frequency, amplitude, titleText)
    figure;
    plot(frequency, amplitude);
    title(titleText);
end

function [amplitude, frequency] = processAudioFile(fileName)
    [audio, fs, ~, ~] = loadAudioFile(fileName);
    [stftResult, frequency, ~] = computeSTFT(audio, fs);
    amplitude = analyzeSignal(stftResult);
end

function [audio, fs, L, T] = loadAudioFile(fileName)
    [audio, fs] = audioread(fileName);
    L = length(audio);
    T = L / fs;
end

function [stftResult, frequency, time] = computeSTFT(audio, fs)
    [stftResult, frequency, time] = stft(audio(:, 1), fs, 'Window', hann(4096), 'OverlapLength', 1024, 'FFTLength', 4096);
end

function amplitude = analyzeSignal(stftResult)
    signalSum = sum(transpose(abs(stftResult)));
    amplitude = signalSum / max(signalSum);
end

function detectedNoiseType = classifyNoise(inputAudioFile)
    [ceilingFanAmplitude, ~] = processAudioFile("music_ceiling-fan.wav");
    [trafficAmplitude, ~] = processAudioFile("music_city-traffic.wav");
    [pressureCookerAmplitude, ~] = processAudioFile("music_pressure-cooker.wav");
    [waterPumpAmplitude, ~] = processAudioFile("music_water-pump.wav");
    [inputAmplitude, ~] = processAudioFile(inputAudioFile);

    rCeilingFan = rmse(ceilingFanAmplitude, inputAmplitude);
    rTraffic = rmse(trafficAmplitude, inputAmplitude);
    rPressureCooker = rmse(pressureCookerAmplitude, inputAmplitude);
    rWaterPump = rmse(waterPumpAmplitude, inputAmplitude);

    rArray = [rCeilingFan, rTraffic, rPressureCooker, rWaterPump];
    minR = min(rArray);

    if minR == rmse(ceilingFanAmplitude, inputAmplitude)
        detectedNoiseType = "Ceiling Fan";
    elseif minR == rmse(trafficAmplitude, inputAmplitude)
        detectedNoiseType = "Traffic";
    elseif minR == rmse(pressureCookerAmplitude, inputAmplitude)
        detectedNoiseType = "Pressure Cooker";
    elseif minR == rmse(waterPumpAmplitude, inputAmplitude)
        detectedNoiseType = "Water Pump";
    end
end
