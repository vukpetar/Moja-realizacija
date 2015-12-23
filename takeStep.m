function [ promjena ] = takeStep( i1, i2 )

global kernel E Alphas target b eps C;


promjena = 0;

if (i1 == i2)
    return
end

alph1 = Alphas(i1);
alph2 = Alphas(i2);
Y1 = target(i1);
Y2 = target(i2);
s = Y1*Y2;


E1 = E(i1);
E2 = E(i2);

if(Y1 ~= Y2)
   L = max(0,alph2-alph1);
   H = min(C,C+(alph2-alph1));
else
   L = max(0,alph2+alph1-C);
   H = min(C,alph2+alph1);
end

if (L == H)
    return
end

eta = 2*kernel(i1,i2) - kernel(i1,i1) - kernel(i2,i2);

if(eta < 0 )
   a2 = alph2 - Y2*(E1-E2)/eta;
   if (a2 < L)
       a2 = L;
   elseif (a2 > H)
       a2 = H;
   end
else

   s = Y1* Y2;
   %f1 = Y1 * (E1 +b) - alph1 * kernel(i1,i1) - s* alph2 * kernel(i1,i2);%y1*v1
   f1 = Y1 * SVMOutput(i1);
   %f2 = Y2 * (E2 +b) - s *alph1 * kernel(i1,i2) - alph2 * kernel(i2,i2);%y2*v2
   f2 = Y2 * SVMOutput(i2);
   L1 = alph1 + s * (alph2 - L);%gama-s*alpha2
   H1 = alph1 + s * (alph2 - H);%gama-s*alpha2
   objL = L1 + L - (L1*f1 + L*f2 + 0.5 * L1^2 * kernel(i1,i1) + 0.5 * L^2 * kernel(i2,i2) + s * L * L1 * kernel(i1,i2));
   objH = H1 + H - (H1*f1 + H*f2 + 0.5 * H1^2 * kernel(i1,i1) + 0.5 * H^2 * kernel(i2,i2) + s * H * H1 * kernel(i1,i2));
   

   if (objL > objH +eps)
       a2 = L;
   elseif(objL < objH - eps)
       a2 = H;
   else
       a2 = alph2;
   end
end

if(a2 < 1e-8)
    a2=0;
elseif(a2 > C-1e-8)
    a2=C;
end


 if (abs(a2 -alph2) < eps * (a2 + alph2 + eps))
     return;
 end
 
a1 = alph1+ s * (alph2-a2);


% b1 = E(i1) + Y1 * (a1 - alph1) * kernel(i1,i1) + Y2 * (a2 - alph2) * kernel(i1,i2) + b;
% b2 = E(i2) + Y1 * (a1 - alph1) * kernel(i1,i2) + Y2 * (a2 - alph2) * kernel(i2,i2) + b;
% b_old = b;
% b = (b1+b2)/2;

Alphas(i1) = a1;
Alphas(i2) = a2;
k = find(Alphas>0 & Alphas<C)';
for i=k
    E(i) = SVMOutput(i) - target(i);
    %E(i) = E(i) + Y1*(a1 - alph1)*kernel(i1,i) + Y2*(a2 - alph2)*kernel(i2,i) + b_old - b;
end
promjena = 1;
return;