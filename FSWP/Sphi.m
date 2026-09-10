x=load('Ref_in.DAT');
subplot(211)
for m=0:4
  semilogx(x(m*4663+1:(m+1)*4663,1),x(m*4663+1:(m+1)*4663,2)+3,'linewidth',1,'linewidth',1.5);
  hold on
  fr=x(m*3997+1:(m+1)*3997,1);
  val=x(m*3997+1:(m+1)*3997,2);
  k=find(fr>20000);k=k(1);
  val(k)+3
end
m=5;
semilogx(x(m*4663+1:end,1),x(m*4663+1:end,2)+3,'linewidth',1,'linewidth',1.5);
  hold on
  fr=x(m*3997+1:end,1);
  val=x(m*3997+1:end,2);
  k=find(fr>20000);k=k(1);
  val(k)+3
grid on
xlabel('frequency offset (Hz)');ylabel('Ref In phase noise (dBrad^2/Hz)')
legend('0','0.001','0.01','0.1','0.2','0.3','location','southwest')

x=load('Ref_out.DAT');
subplot(212)
for m=0:5
  semilogx(x(m*4663+1:(m+1)*4663,1),x(m*4663+1:(m+1)*4663,2)+3,'linewidth',1,'linewidth',1.5);
  hold on
  fr=x(m*3997+1:(m+1)*3997,1);
  val=x(m*3997+1:(m+1)*3997,2);
  k=find(fr>20000);k=k(1);
  val(k)+3
end
grid on
xlabel('frequency offset (Hz)');ylabel('Ref Out phase noise (dBrad^2/Hz)')
legend('0','0.001','0.01','0.1','0.2','0.3','location','southwest')
