function [ vrijednost ] = SVMOutput( i )    
global target Alphas kernel b
vrijednost = sum(target .* Alphas .* kernel(i,:)') - b;
end