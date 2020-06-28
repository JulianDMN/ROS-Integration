function q = Inverse_kin(q0,objective)
%INVERSE_KIN Summary of this function goes here
%   Detailed explanation goes here
    options = optimset('Algorithm','levenberg-marquardt','Display','off');
    fun = (@(q)prob(q,objective));
    q = fsolve(fun,q0,options);
end

