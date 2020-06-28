function pose = getpose(p,theta)
    sp = p(:,1:2);
    v = [sp vecnorm(sp,2,2).*tan(theta)];
    v = v./vecnorm(v,2,2);
    idxs = find(sum(sp==[0 0],2)==2);
    v(idxs,:) = repmat([0 0 1],length(idxs),1);
    pose = [v p];
end