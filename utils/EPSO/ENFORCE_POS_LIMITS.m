function [ new_pos, new_vel ] = ENFORCE_POS_LIMITS( D, popSize, pos, Xmin, Xmax, vel, Vmin, Vmax )
% Enforces search space limits
new_pos = pos;
new_vel = vel;
for i = 1 : popSize
    for j = 1 : D
        if new_pos( i, j ) < Xmin( j )
            new_pos( i, j ) = Xmin( j );
            if new_vel( i, j ) < 0
                new_vel( i, j ) = -new_vel( i, j );
            end
        elseif new_pos( i, j ) > Xmax( j )
            new_pos( i, j ) = Xmax( j );
            if new_vel( i, j ) > 0
                new_vel( i, j ) = -new_vel( j );
            end
        end
        % Check velocity in case of asymmetric velocity limits
        if new_vel( i, j ) < Vmin( j )
            new_vel( i, j ) = Vmin( j );
        elseif new_vel( i, j ) > Vmax( j )
            new_vel( i, j ) = Vmax( j );
        end
    end
end
end