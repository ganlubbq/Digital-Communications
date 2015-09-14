%Simplex Signalling
M = input('Number of Simplex signals needed: ');
freq = zeros(1, M);
for i = 1:M
    freq(i) = i;
end

binString = input(['Enter the binary data (ensure that is a product of '...
             num2str(M/2) '): '], 's');
binString = num2str(binString);

Avg = zeros(1, M);
for i=1:M
    Avg(i) = 1/M;
end

pulses = zeros(length(binString)*2/M, M);
for i=1:M/2:length(binString)
    string = binString(i:i+(M/2)-1);
    pulses(1 + floor((i-1)*2/M), bin2dec(string)+1) = 1;
    for j = 1:2*length(string)
        pulses(1 + floor((i-1)*2/M), j) = pulses(1 + floor((i-1)*2/M), j) - Avg(j);
    end
end

fc = 3;
smooth = 100;
nSize = 2*length(binString)/M;
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
