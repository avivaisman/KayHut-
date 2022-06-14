function output=CheckRot(Acc,acc)

      output=zeros(size(Acc,2),4);

for i=1:size(Acc,2)

        try
            output(i,:)=vrrotvec(acc(:,i),Acc(:,i));
        catch
            output(i,:)=output(i-1,:);
        end
end

