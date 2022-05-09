
function f=findpoint(x,y,sx,sy)
    n=length(x);
    f=1;
    for i=1:n
        if x(i)==sx && y(i)==sy
            f=0;
            break;
        end
    end
end