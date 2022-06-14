clear all
close all

method_number=2; %choose method number (to include bias, choose 2)
IterNum=20; %number of iterations for iterative algorithm preformance analysis
prediction_score=zeros(1,20);
BiasFactor=linspace(0,1,20); %for incremental change in bias (method #1)

for k=(1:length(BiasFactor))
    score=zeros(1,IterNum);
    for j=1:IterNum
        
        %% Trajectory Creator
        
        %Generate 2 different trajectories (and equivalent velocities & accelerations),
        %constructed from different sin functions.
        
        
        [Acc_sim, Loc_sim, Vel_sim, turn_x_sim, turn_y_sim]=GenTraj(60); % tajectory for sim channel
        [Acc_ins, Loc_ins, Vel_ins, turn_x_ins,turn_y_ins]=GenTraj(60); % trajectory for ins channel
        
        %plot trajectories
        % figure(1)
        % subplot(1,2,1)
        % plot(Loc_ins(1,:),Loc_ins(2,:))
        % title('trajectory #1')
        % xlabel('x[m]')
        % ylabel('y[m]')
        % subplot(1,2,2)
        % plot(Loc_sim(1,:),Loc_sim(2,:))
        % title('trajectory #2')
        % xlabel('x[m]')
        % ylabel('y[m]')
        
        %% Corrupt vectors
        
        %take ins trajectory and "corrupt" it, by including measurment errors
        %(Bias, SF and R)
        
        R=rotz(MyRand(-90,90,1,0)); %Rotation Matrix
        SF=MyRand(0.0003,0.003,1,0); %Scale Facrtor
        Bias=[MyRand(-1,1,1,0);MyRand(-1,1,1,0);0]; %Bias
        acc=Acc_ins; %new ins raw data input
        
        for i=1:size(Acc_ins,2)
            if method_number == 1
                acc(:,i)=R*SF*Acc_ins(:,i)+bias*BiasFactor(k); %only for method #1
            else
                acc(:,i)=R*SF*Acc_ins(:,i)+Bias;
            end
        end
        acc(3,:)=0; %2D Problem
        
        %% Plot Vectors (only for method #1)
        if method_number==1
            
            
            % close all
            % subplot(2,2,1)
            % plot(Loc_ins(1,:),Loc_ins(2,:))
            %
            % hold all
            % grid on
            % quiver(Loc_ins(1,1:end-2),Loc_ins(2,1:end-2),Acc_ins(1,:)*5,Acc_ins(2,:)*5,1)
            % quiver(Loc_ins(1,1:end-2),Loc_ins(2,1:end-2),acc(1,:)*5,acc(2,:)*5,1)
            % legend('Cars Location between T=0 to T=60', 'Real Acc.', 'Measured Acc.','Location','best')
            % title('Trajectory xyz - INS Channel')
            % xlabel('x [m]')
            % ylabel('y [m]')
            %
            % AngleVec_ins=CheckRot(Acc_ins,acc);
            % subplot(2,2,2)
            % plot(1:58,AngleVec_ins(:,4))
            % title('Angle Between Vectors')
            % xlabel('Vector Number')
            % ylabel('Angle [rad]')
            % subplot(2,2,3)
            %
            % plot(Loc_sim(1,:),Loc_sim(2,:))
            %
            % hold all
            % grid on
            % quiver(Loc_sim(1,1:end-2),Loc_sim(2,1:end-2),Acc_sim(1,:)*5,Acc_sim(2,:)*5,1)
            % quiver(Loc_sim(1,1:end-2),Loc_sim(2,1:end-2),acc(1,:)*5,acc(2,:)*5,1)
            % legend('Cars Location between T=0 to T=60', 'Real Acc.', 'Measured Acc.','Location','best')
            % title('Trajectory xyz - SIM Channel')
            % xlabel('x [m]')
            % ylabel('y [m]')
            %
            % AngleVec_sim=CheckRot(Acc_sim,acc);
            % subplot(2,2,4)
            % plot(1:58,AngleVec_sim(:,4))
            % title('Angle Between Vectors')
            % xlabel('Vector Number')
            % ylabel('Angle [rad]')
            
            %% Classifier 1 (method #1)
            
            
            input=acc; %define input for classifier
            ClassThresh=0.35; %manualy defined classification threshold
            
            %randomly choose output channel
            Choose_InputChannel=rand(1,IterNum);
            if Choose_InputChannel(j)>0.5
                output=Acc_ins;
            else
                output=Acc_sim;
            end
            
            
            AngleVec=CheckRot(output,input); %messure angle between individual vectors
            
            
            if std(AngleVec(:,4))> ClassThresh
                disp('the output is sim!')
                if output==Acc_sim
                    score(j)=1;
                else
                    score(j)=0;
                end
            else
                disp('the output is ins!')
                if output==Acc_ins
                    score(j)=1;
                else
                    score(j)=0;
                end
            end
            
        end
        
        %% Classifier #2
        
        if method_number==2
            
            input=acc; %define input for classifier
            
            %randomly choose output channel
            Choose_InputChannel=rand(1,IterNum);
            if Choose_InputChannel(j)>0.5
                output=Acc_ins;
            else
                output=Acc_sim;
            end
            
            [check, cordif_1, cordif_2]=CheckCorr(input,output);
            %noemalize rotate and check correlation between vector components.
            %for more details, check function.
            
            if CheckCorr(input,output) == 0
                disp('the output is sim!')
                if output==Acc_sim
                    score(j)=1;
                else
                    score(j)=0;
                    %         [check, cordif_1, cordif_2]=CheckCorr(input,output); %for
                    %         preformance investogation
                end
            else
                disp('the output is ins!')
                if output==Acc_ins
                    score(j)=1;
                else
                    score(j)=0;
                    %         [check, cordif_1, cordif_2]=CheckCorr(input,output); %for
                    %         preformance investogation
                end
            end
        end
        
    end
    
    prediction_score(k)=sum(score)/length(score);
    
end

plot(prediction_score)

