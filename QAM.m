%Quadrature Amplitude Modulation

qamType = input('Select the type of QAM needed: ');
SNR = input('Enter SNR (in dB): ');
var = 0.5/(10^0.1*SNR);

m = sqrt(qamType);
M_val = zeros(1, m);
for i = 1:m
    M_val(i) = 2 * i - m - 1;
end

binString = input(['Enter the binary data (ensure that is a product of '...
             num2str(2*log2(m)) '): '], 's');
binString = num2str(binString);

binComb = dec2bin(0:m - 1);
nSize = floor(length(binString) / log2(m));
pulsesr = zeros(1, floor(nSize/2));
pulsesi = zeros(1, floor(nSize/2));

keySet = cell(m, 1);
grayCode = cell(1, 1);
for i = 1:m
    grayCode = binComb(i,:);
    for j=2:length(binComb(i,:))
        grayCode(1,j) = num2str(xor(str2double(binComb(i,j)),str2double(binComb(i,j-1))));
    end
    keySet{i} = grayCode;
end

mapObj = containers.Map(keySet, M_val);
for i = 1:2:nSize
    pulsesr(floor(i/2)+1) = mapObj(binString((i - 1)*log2(m) + 1:i*log2(m)));
    pulsesi(floor(i/2)+1) = mapObj(binString(i*log2(m) + 1:(i + 1)*log2(m)));
end

fc = 10;
smooth = 100;
carrier = zeros(1, smooth * fc * length(pulsesr));
for i = 1:(smooth * fc * length(pulsesr) - 1)
    carrier(i) = cos(2*pi*i/smooth) * pulsesr(floor(1 + i/(fc*smooth)));
end

carrieri = zeros(1, smooth * fc * length(pulsesi));
for i = 1:(smooth * fc * length(pulsesi) - 1)
    carrieri(i) = sin(2*pi*i/smooth) * pulsesi(floor(1 + i/(fc*smooth)));
end


maxVal = m - 1 + 0.5;
nSize = length(pulsesr);
carrierAxis = linspace(0, nSize, smooth * fc * length(pulsesr));
modulated = carrier + carrieri;
figure;
plot(carrierAxis, modulated)
axis([0 nSize -maxVal maxVal])
title('Modulated Waveform')
% figure;
% plot(carrierAxis, carrieri)
% axis([0 nSize -maxVal maxVal])
% title('Modulated waveform for Quadrature phase component')

scatterx = zeros(1,nSize);
scattery = zeros(1,nSize);

for i = 1:nSize
    scatterx(i) = pulsesr(i) + normrnd(0,var);
    scattery(i) = pulsesi(i) + normrnd(0,var);
end

figure;
scatter(scatterx, scattery)
grid on
title('Scatter Plot of Symbols')