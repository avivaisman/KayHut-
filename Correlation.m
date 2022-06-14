%% Preliminary defenitions
BinArrSize=5000; %define vector size
NumOfVec=20; %define number of vectors

% Generate 20 Binary Vectors + Ref Vector
Mask=rand(NumOfVec+1,BinArrSize);
Channels=zeros(NumOfVec+1,BinArrSize);
Channels(Mask>0.5)=1;
Channels(Channels==0)=-1;

%Create a Random Refference Vector
RefVec=Channels(21,:);
Channels=Channels(1:20,:);

%% Calculate Correlation Matrix With the Random RefVec
Corr=dot(repmat(RefVec,20,1), Channels,2);
figure(1)
cdfplot(Corr)
title(['min corr=' num2str(min(Corr))])

%% Improve#1 RefVector - Best Mean Correlation

RefVec=zeros(1,5000);
for i=1:size(Channels,2)
    %check inclination of vector set at idx i, for -1 or 1. define
    %RefVec variables respectivly
    sumpos=sum(Channels(:,i));
    if sumpos>0
        RefVec(i)=1;
    else
        RefVec(i)=-1;
    end
end

Corr=dot(repmat(RefVec,20,1), Channels,2); %calculate correlation with current
% RefVec by dot-product.
figure(1)
hold all
cdfplot(Corr)
title(['min corr=' num2str(min(Corr))])

%% Improve#2 RefVector - final refinement

prevmin=0;
CurrMin=min(Corr); %current min. correlation

while prevmin~=CurrMin
    prevmin=CurrMin;
    for k=1:20
        i=1;
        PastCorr=min(Corr);
        idx=1:5000;
        while i<length(idx)
            RefVec(idx(i))=RefVec(idx(i))*-1; %change the i'th element
            Corr=dot(repmat(RefVec,20,1), Channels,2); %calculate new correlation vector
            CurrMin=min(Corr) ;%new min corr value
            if CurrMin>PastCorr
                PastCorr=CurrMin;
                %plot new CDF
                figure(2)
                clf
                cdfplot(Corr)
                title(['min corr=' num2str(CurrMin)])
            else
                RefVec(idx(i))=RefVec(idx(i))*-1; %revert change if min correlation got worse
                Corr=dot(repmat(RefVec,20,1), Channels,2);
                i=i+1;
                CurrMin=min(Corr);
            end
        end
    end
end

figure(1)
hold all
cdfplot(Corr)
legend('Random RefVec', 'Mean-Best RefVec', 'Improved RefVec','Location','best')


