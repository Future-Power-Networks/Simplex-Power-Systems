
clear Phi_vec_trim

A=GminSS.A;
[Phi,D]=eig(A);
Psi=inv(Phi); 

ModeSel = 158;
Phi_vec=Phi(:,ModeSel);

StateString=GminStateStr;

i=1; sp=1;
for k =1: N_Apparatus
    if ApparatusType{k} <= 89  %apparatus
        Phi_vec_trim(i:i+1) = Phi_vec(sp+1:sp+2,1);
        sp = sp+length(ApparatusStateStr{k});
        i = i+2;      
    else %floating bus and passive load: not considered           
    end
end

Phi_vec_trim = Phi_vec_trim.'; % non-conjugate transpose.

Mode_Rad = D(ModeSel, ModeSel);
Mode_Hz = Mode_Rad/2/pi;
freq_sel = imag(Mode_Hz);
Phi_vec_trim(:,2) = abs(Phi_vec_trim(:,1));
Phi_vec_trim(:,3) = angle(Phi_vec_trim(:,1));