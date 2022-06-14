function [Acc, Loc, Vel,turns_x, turns_y]=GenTraj(seconds)

time=[1:seconds];
turns_x=MyRand(3,10,1,1);
alpha=(pi*turns_x)/seconds;
Traj_x = @(x) sin(alpha*x);
Loc_x = Traj_x(time);
Vel_x = diff(Loc_x);
Acc_x = diff(Vel_x);

turns_y=MyRand(3,10,1,1);
beta=(pi*turns_y)/seconds;
Traj_y = @(y) sin(beta*y);
Loc_y = Traj_y(time);
Vel_y = diff(Loc_y);
Acc_y = diff(Vel_y);

Acc=[Acc_x;Acc_y;zeros(1,length(Acc_x))];
Loc=[Loc_x;Loc_y;zeros(1,length(Loc_x))];
Vel=[Vel_x;Vel_y;zeros(1,length(Vel_x))];