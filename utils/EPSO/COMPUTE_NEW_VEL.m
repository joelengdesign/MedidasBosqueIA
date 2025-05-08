function [new_vel] = COMPUTE_NEW_VEL(D, pos, myBestPos, gbest, vel, Vmin, Vmax, weights, communicationProbability)
% Compute inertial term (element-wise multiplication)
inertiaTerm = weights(:,1) .* vel;  % (N x 1) .* (N x D) → (N x D)

% Compute memory term (element-wise)
memoryTerm = weights(:,2) .* (myBestPos - pos);  % (N x 1) .* (N x D) → (N x D)

cooperationTerm = weights(:, 3).*(gbest.* ( 1 + weights(:,4) * normrnd( 0, 1 )) - pos);

% Communication matrix (N x D)
communicationProbabilityMatrix = rand(size(weights,1), D) < communicationProbability;

% Apply communication matrix (element-wise)
cooperationTerm = cooperationTerm .* communicationProbabilityMatrix;

% Sum all terms
new_vel = inertiaTerm + memoryTerm + cooperationTerm;

% Clamp velocity (element-wise)
new_vel = max(min(new_vel, Vmax), Vmin);  % works if Vmax/Vmin are (1 x D) or scalars

end
