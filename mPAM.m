%M - PAM implementation in MATLAB

m = input('Enter the value of M: ');
SNR = input('Enter SNR (in dB): ');
var = 0.5/(10^0.1*SNR);
M_val = zeros(1, m);

for i = 1:m
    M_val(i) = 2 * i - m - 1;
end

binString = input(['Enter the binary data (ensure that is a product of '...
             num2str(log2(m)) '): '], 's');
binString = num2str(binString);

binComb = dec2bin(0:m - 1);
nSize = floor(length(binString) / log2(m));
pulses = zeros(1, nSize+1);

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
pulses(nSize+1) = pulses(nSize);
x = 0:nSize;
maxVal = m - 1 + 0.5;
[XX, YY] = stairs(x, pulses);

fc = 10;
smooth = 100;
carrier = zeros(1, smooth * fc * (length(YY) - 1)/2);
for i = 1:smooth * fc * (length(YY) - 1)/2
    carrier(i) = cos(2*pi*i/smooth) * YY(floor(1 + (2*i)/(fc*smooth)));
end

carrierAxis = linspace(0, nSize, smooth * fc * (length(YY)- 1)/2);
figure;
plot(XX, YY)
hold on
plot(carrierAxis, carrier)
axis([0 nSize -maxVal maxVal])
title('Plot showing modulated waveform')
hold off

scatterVal = zeros(1,nSize);
for i=1:nSize
    scatterVal(i) = pulses(i) + normrnd(0, var);
end
scatAxis = zeros(1, nSize);
figure;
scatter(scatterVal, scatAxis)
grid on
axis([-maxVal maxVal -1 1])
title('Scatter Plot of Symbols')