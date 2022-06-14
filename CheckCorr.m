function [check, cordif_1, cordif_2] =CheckCorr(input,output)

for dim=1:2 %run correlation test for both dimensions
    j=1;
while j<360 %rotate vector component, 1 degree at a time, and search for best correlation
    R=rotz(1); 
    for i=1:size(output,2)
         output(:,i)=R*output(:,i);
    end
        %calculate correlation between current rotation of the output
        %channel VS input
        correlation(dim,j)=sum((normalize(output(dim,:)).^2).*(normalize(input(dim,:)).^2));
        j=j+1;
    end
end

correlation=correlation(:,30:end-30); %trim correlation vector
cordif_1=max(correlation(1,:))-min(correlation(1,:)); %for investigation purposes
cordif_2=max(correlation(2,:))-min(correlation(2,:)); %for investigation purposes

class_threshold = 20; %manually tuned classification threshold
if cordif_1>class_threshold || cordif_2>class_threshold
    check=1;
else
    check=0;
end


