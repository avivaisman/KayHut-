function output = MyRand(xmin,xmax,n,round)
if round == 1
    output = fix(xmin+rand(1,n)*(xmax-xmin));
else
    output = xmin+rand(1,n)*(xmax-xmin);
end