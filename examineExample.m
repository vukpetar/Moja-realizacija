function [ promjena ] = examineExample( i2 )

global Alphas E target eps C; 

y2 = target(i2);
alph2 = Alphas(i2);
E2 = E(i2);
r2 = E2*y2;

promjena = 0;
if( r2 < -eps & alph2 < C) | (r2 > eps & alph2 > 0)
    nonZeroIndexes = find (Alphas ~= 0 & (Alphas < C | Alphas > -C));
    if ~isempty(nonZeroIndexes)
        [~, indexes] = sort(E);
        %kada je E2 pozitivno uzimamo trening podatke sa najmanjom greskom 
        if E(i2) > 0
            if indexes(1) == i2
                i1 = indexes(2);
            else
                i1 = indexes(1);
            end
        %kada je E2 negativno uzimamo trening podatke sa najvecom greskom greskom 
        else
            if (indexes(end) == i2)
                i1 = indexes(end-1);
            else
                i1 = indexes(end);
            end
        end
        
        if (takeStep(i1,i2) == 1)
            promjena = 1;
            return;
        end

        % petlja kroz sve trening primjere koji su razliciti od C i od 0.
        % pocetak u slucajnom trening primjeru
        randomIndexes = randperm(length(nonZeroIndexes));
        for j=1:length(nonZeroIndexes)
            if (takeStep(randomIndexes(j),i2) == 1)
                promjena = 1;
                return
            end
        end
    end

    %  petlja kroz sve trening primjere, sa pocetkom u slucajnom trening
    %  primjeru
    randomIndexes = randperm(length(Alphas));
    for j=1:length(Alphas)
        if (takeStep(randomIndexes(j),i2) == 1)
             promjena = 1;
             return
        end
    end
end

return