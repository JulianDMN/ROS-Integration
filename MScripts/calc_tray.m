function qs = calc_tray(q0,pf,type,grip,n)
%CALC_TRAY Summary of this function goes here
%   Detailed explanation goes here
    qs = zeros(n*(size(pf,1)-1)+1,length(q0));
    qs(1,:) = q0;
    % Interpolate Pose
    for i=2:size(pf,1)
        p0 = pf(i-1,:);
        p1 = pf(i,:);
        if type(i-1)
            % Linear Interpolation
            D = p1-p0;
            for j=1:n
                k = (i-2)*n+j+1;
                t = j/n;
                pj = p0+(t*D);
                qj = Inverse_kin(qs(k-1,:),pj);
                qs(k,:) = qj;
            end
        else
            % Spherical Interpolation
            O = acos(dot(p0/norm(p0),p1/norm(p1)));
            for j=1:n
                k = (i-2)*n+j+1;
                t = j/n;
                pj = (sin(O*(1-t))/sin(O))*p0 + (sin(t*O)/sin(O))*p1;
                qj = Inverse_kin(qs(k-1,:),pj);
                qs(k,:) = qj;
            end
        end
%         k = (i-1)*n+1;
%         qj = Inverse_kin(qs(k-1,:),p1);
%         qs(k,:) = qj;
    end
    for i=1:size(qs,1)
        if(grip(floor((i-1)/8)+1)==1)
            qs(i,5)=0.225;
        else
            qs(i,5)=0;
        end
    end
end

