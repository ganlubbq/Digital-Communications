%Binary Coded Signalling
m = input('Number of signals needed: ');
M = m/2;
freq = zeros(1, M);
for i = 1:M
    freq(i) = i;
end

binString = input(['Enter the binary data (ensure that is a product of '...
             num2str(M) '): '], 's');
binString = num2str(binString);


pulses = zeros(length(binString)/M, M);
for i=1:M:length(binString)
    string = binString(i:i+M-1);
    for j = 1:length(string)
        num = str2double(string(j));
        if num == 0
            pulses(1 + floor((i-1)/M), j) = -1;
        else
            pulses(1 + floor((i-1)/M), j) = 1;
        end
    end
end

fc = 3;
smooth = 100;
nSize = length(binString)/M;
signal = zeros(1, nSize*smooth*fc);
for i = 1:smooth*fc:length(signal)
    temp = zeros(1, smooth*fc);
    for j = 1:smooth*fc
        con = 0;
        for k = 1:M
            con = con + pulses(1+ floor((i-1)/(smooth*fc)),k) * sin(2*pi*freq(k)*j/smooth); 
        end
        temp(j) = con;
    end
    signal(i:i + smooth*fc - 1) = temp;
end

xAxis = linspace(0, nSize, fc * smooth * nSize);
plot(xAxis, signal)
