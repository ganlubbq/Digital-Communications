%Bi-Orthogonal Signalling
M = input('Number of Bi-Orthogonal signals needed: ');
m = M/2;
freq = zeros(1, m);
for i = 1:m
    freq(i) = i;
end
binString = input(['Enter the binary data (ensure that is a product of '...
             num2str(m) '): '], 's');
binString = num2str(binString);

pulsesFreq = zeros(1,length(binString)/m);
for i=1:m:length(binString)
    string = binString(i:i+m-1);
    val = bin2dec(num2str(string));
    if val < m
        pulsesFreq(1 + floor(i/m)) = -freq(val + 1);
    else
        pulsesFreq(1 + floor(i/m)) = freq(val + 1 - m);
    end
end

fc = 3;
smooth = 100;
nSize = length(binString)/m;
signal = zeros(1, smooth * fc * nSize);

for i = 1:smooth * fc * nSize
    Freq = pulsesFreq(1 + floor((i-1)/(smooth*fc)));
    signal(i) = sin(2*pi*Freq*i/smooth);
end

xAxis = linspace(0, nSize, fc * smooth * nSize);
plot(xAxis, signal)