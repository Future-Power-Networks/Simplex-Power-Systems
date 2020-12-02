function [Layer1, Layer2] = GbLayer12(Residue,ZmVal,N_Bus,DeviceType,modei,DeviceSel,FreqSel,ModeSel)

pin = 1;   %pointer to input
pout = 1;  %pointer to output
for k = 1:N_Bus
    if DeviceType{k} <= 89  %apparatus
        %Greybox layer 1
        Layer1All(k) = sqrt( Residue(k).dd*conj(Residue(k).dd) + Residue(k).dq*conj(Residue(k).dq)...
            +Residue(k).qd*conj(Residue(k).qd) +Residue(k).qq*conj(Residue(k).qq) )...
            * sqrt( ZmVal(k).dd*conj(ZmVal(k).dd) + ZmVal(k).dq*conj(ZmVal(k).dq)...
            + ZmVal(k).qd*conj(ZmVal(k).qd) + ZmVal(k).qq*conj(ZmVal(k).qq) );
        %Greybox layer 2
        Layer2All(k) = -1 * ( Residue(k).dd*ZmVal(k).dd + Residue(k).qd*ZmVal(k).dq ...
                    + Residue(k).dq*ZmVal(k).qd + Residue(k).qq*ZmVal(k).qq ) ;        
        pin = pin + 4;    %4 inputs and 5 outputs.
        pout = pout + 5;
    else %passive load.
        pin = pin + 2;
        pout = pout + 2;
   end
end

%%
%%diagrams drawing
close(figure(14+modei));
figure(14+modei)
Count=0;
for k = 1:N_Bus
   if (ismember(k,DeviceSel)) %if selected 
       Count = Count + 1;
       Layer1(Count) = Layer1All(k);
       Layer2.real(Count) = real(Layer2All(k));
       Layer2.imag(Count) = imag(Layer2All(k));
       VecLegend{Count} = ['Device',num2str(k)];
       c(Count) = categorical({['Device',num2str(k)]});
   end
end
clear title
subplot(2,2,[1,3]);
pie(Layer1);
title ('Greybos Level-1');
legend(VecLegend,'Location','southwest');

subplot(2,2,2);
b=bar(c, Layer2.real);
title ('Greybos Level-2 Real');
for i=1:Count
    text(i-0.4,Layer2.real(i),num2str(Layer2.real(i)));
end

subplot(2,2,4);
b=bar(c, Layer2.imag);
b.FaceColor = 'flat';
b.CData = [1,0.5,0];
title ('Greybos Level-2 Imag');
for i=1:Count
    text(i-0.4,Layer2.imag(i),num2str(Layer2.imag(i)));
end

TitStr = ['Mode: ',num2str(ModeSel,'%.2f'), ' Hz'];
mtit(TitStr, 'color',[1 0 0], 'xoff', -0.3);

end
