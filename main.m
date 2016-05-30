clear all
clc
X = []; Y=[];
figure;
trainPoints=X;
trainLabels=Y;
clf;
axis([-5 5 -5 5]);
if isempty(trainPoints)
    symbols = {'o','x'};
    classvals = [-1 1];
    trainLabels=[];
    hold on; 
    xlim([-5 5]); ylim([-5 5]);
    
    for c = 1:2
        title(sprintf('Click to create points from class %d. Press enter when finished.', c));
        [x, y] = getpts;
        
        plot(x,y,symbols{c},'LineWidth', 2, 'Color', 'black');
        
        trainPoints = vertcat(trainPoints, [x y]);
        trainLabels = vertcat(trainLabels, repmat(classvals(c), numel(x), 1));        
    end

end
C = 1;
[w b alpha]  = trainSVM(trainPoints, trainLabels , C );
p=length(b); m=size(trainPoints,2);
 if m==2
    k = -w(1)/w(2);
    b0 = - b/w(2);
    bdown=(-b-1)/w(2);
    bup=(-b+1)/w(2);
    for i=1:p
        hold on
        h = refline(k,b0(i)); 
        set(h, 'Color', 'r') 
        hdown=refline(k,bdown(i));
        set(hdown, 'Color', 'b') 
        hup=refline(k,bup(i));
        set(hup, 'Color', 'b') 
    end  
 end
xlim([-5 5]); ylim([-5 5]);
