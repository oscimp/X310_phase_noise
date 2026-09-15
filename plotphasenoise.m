subplot(211);
Sphi=[-123 -123 -110 -110 -91 -91 -85 -85 -79.5 -79.5]
snr= [0.99741 0.99755 0.99739 0.99737 0.99654 0.99650 0.99361 0.99361 0.98837 0.98839]
plot(Sphi,snr)
hold on
Sphi=[-123:-79];
sigma2=10.^(Sphi/10)*4e6*70/200;  % 200 MHz noise but sampling a BPSK signal on a 70 MHz carrier
plot(Sphi,exp(-sigma2/2));
xlabel('Sphi (dBrad^2/Hz)');ylabel('SNR');legend('measurements','exp(-sigma^2/2)','location','southwest')
