%PSK Modulation

m = input('Enter the value of M: ');
M_val = zeros(1, m);
SNR = input('Enter SNR (in dB): ');
var = 0.5/(10^0.1*SNR);

for i = 1:m
    M_val(i) = i;
end

binString = input(['Enter the binary data (ensure that is a product of '...
             num2str(log2(m)) '): '], 's');
binString = num2str(binString);

binComb = dec2bin(0:m - 1);
nSize = floor(length(binString) / log2(m));
pulses = zeros(1, nSize);

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
for i = 1:nSize
    pulses(i) = mapObj(binString((i - 1)*log2(m) + 1:i*log2(m)));
end


fc = 10;
smooth = 100;
carrier = zeros(1, smooth * fc * (length(YY) - 1)/2);
scatterx = zeros(1,nSize);
scattery = zeros(1,nSize);

for i = 1:smooth * fc * nSize - 1
    carrier(i) = cos((2*pi*i/smooth) + 2 * pi/m * (pulses(floor(i/(fc*smooth)) + 1) - 1));
end

carrierAxis = linspace(0, nSize, smooth * fc * (length(YY)- 1)/2);
figure;
plot(carrierAxis, carrier)
axis([0 nSize -maxVal maxVal])
title('Plot showing Modulated waveform')


for i = 1:nSize
    scatterx(i) = cos(2 * (pi/m) * (pulses(i) - 1));
    scattery(i) = sin(2 * (pi/m) * (pulses(i) - 1));
    scatterx(i) = scatterx(i) + normrnd(0,var);
    scattery(i) = scattery(i) + normrnd(0,var);
end
figure;
scatter(scatterx, scattery)
grid on
title('Scatter Plot')