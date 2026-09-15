format long
clear all
close all

pkg load signal
fs=10e6;
code_dur=40e-3
N=fs*code_dur;

d=dir('2*_noise*');
for l=1:length(d)
  d(l).name
  dd=dir([d(l).name,'/*.dat']);
  if (length(dd)==2)
    f1=fopen([d(l).name,'/',dd(1).name]);
    f2=fopen([d(l).name,'/',dd(2).name]);
    x1=fread(f1,2*N,'int16');x1=x1(1:2:end)+j*x1(2:2:end);
    x2=fread(f2,2*N,'int16');x2=x2(1:2:end)+j*x2(2:2:end);
    y=xcorr(x1,x2,N/2+1001,'unbiased');
    [s,spos]=max(abs(y));
    spos=spos-N/2;
    fseek(f2,0,SEEK_SET);
    fseek(f1,(spos-1)*2*2,SEEK_SET);
    p=1;
    do
      x1=fread(f1,2*N,'int16');x1=x1(1:2:end)+j*x1(2:2:end);
      x2=fread(f2,2*N,'int16');x2=x2(1:2:end)+j*x2(2:2:end);
      y=xcorr(x1,x2,N/2+1001,'normalized');
      [s,spos]=max(abs(y));
      if abs(spos-N/2)>5
         printf("error\n");
      end
      bb=polyfit([-1:1],abs(y(spos-1:spos+1)),2);
      xx=linspace(-1,1,100);
      yy=polyval(bb,xx);
      if (p==5) figure(99);plot(abs(y));hold on;plot(linspace(spos-1,spos+1,100),yy);end
      sig(p)=s; % max(yy);
      noi(p)=var(abs(y(spos+1000:spos+N/2)));
      a(p)=arg(y(spos));
      p=p+1;
   until ((length(x1)!=N) || (p>100));
   figure(1);
    subplot(211);plot((sig.^2)./noi);hold on
    mean((sig.^2)./noi);
%    subplot(212);plot(a);hold on
    fclose(f1);
    fclose(f2);
    mean(sig)
    mean(noi);
    %std(snr)/mean(snr)
    %mean(snr)
  end
end
%subplot(211)
legend('0.01','0.05','0.1','0.0','0.0')
