function [par,bias,alphas]=trainSVM(features, trainLabels, Cslack)


global kernel E b Alphas target eps C x;
x = features;
target = trainLabels;
kernel = x*x';
C = Cslack;
w = zeros(1,size(x,2))';
eps = 10^(-3);

dataSetSize = length(target);

b = 0;
Alphas = zeros(dataSetSize,1);


E = -target;

numChanged = 0;
examineAll = 1;


while numChanged >0 || examineAll
    numChanged = 0;
    if (examineAll)
        for i=1:length(target)
            numChanged = numChanged + examineExample(i);
        end
    else
        for i=1:length(target)
            if (Alphas(i)> 0 && Alphas(i) < C)
                numChanged = numChanged + examineExample(i);
            end
        end
    end
    
    if (examineAll == 1)
        examineAll = 0;
    elseif (numChanged == 0)
        examineAll = 1;
    end
end
id = find(Alphas < C & Alphas >0);
if(~isempty(id))
    b = mean(target(id)' - (target.*Alphas)'*kernel(:, id));
else
    id = find(Alphas >0);
%     [a poz] = min(Alphas(id));
%     b = target(poz)' - (target.*Alphas)'*kernel(:, poz);
    
    b = mean(target(id)' - (target.*Alphas)'*kernel(:, id));
end
bias = b;
alphas = Alphas;
for i = 1:length(Alphas)
    w = w+Alphas(i)*target(i)*x(i,:)';
end
par = w;