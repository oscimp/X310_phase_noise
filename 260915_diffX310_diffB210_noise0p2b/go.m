format long
pkg load signal
N=1E6;
f1=fopen('usrp_samples_ch0.dat');d=fread(f1,N,'int16');x1=d(1:2:end)+j*d(2:2:end);
f2=fopen('usrp_samples_ch4.dat');d=fread(f2,N,'int16');x2=d(1:2:end)+j*d(2:2:end);
y=xcorr(x1,x2,N/2,'unbiased');
[s,spos]=max(abs(y));
spos=spos-N/2
fseek(f2,0,SEEK_SET);
fseek(f1,(spos-1)*2*2,SEEK_SET);
x1=fread(f1,2*N,'int16');x1=x1(1:2:end)+j*x1(2:2:end);
x2=fread(f2,2*N,'int16');x2=x2(1:2:end)+j*x2(2:2:end);

% plot([-N+1:N-1],abs(xcorr(x1,x2)))  % check alignement

ratio=std(x1)/std(x2)
dangle=mean(angle(x1./x2)(100:end-100))

figure
plot(angle(x1./x2))
figure
ans*180/pi
subplot(211);plot(imag(x1-x2*exp(j*dangle)*ratio));ylim([-40 40])
subplot(212);plot(real(x1-x2*exp(j*dangle)*ratio));ylim([-40 40])
mean(imag(x1-x2*exp(j*dangle)*ratio))
figure
subplot(211);hist(real(x1-x2*exp(j*dangle)*ratio),1024);xlabel('bin number (bit)');ylabel('count')
subplot(212);hist(imag(x1-x2*exp(j*dangle)*ratio),1024);xlabel('bin number (bit)');ylabel('count')
