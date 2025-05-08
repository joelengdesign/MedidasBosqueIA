function [new_pos, new_vel] = COMPUTE_NEW_POS(pos, vel)
pos = pos + vel;
new_vel = vel;
pos = round(pos);
pos(pos < 0) = 0;
pos(pos > 40) = 40;
rowsToReplace = ismember(pos, [0 0], 'rows');
if any(rowsToReplace)
    pos(rowsToReplace, :) = repmat([0 2], sum(rowsToReplace), 1); 
end
new_pos = pos;
end