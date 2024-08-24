function [K, R, t] = estimate_params(P)
    % Compute the intrinsic K, rotation R and translation t from
    % the given camera matrix P.
    
    % Perform Singular Value Decomposition (SVD) to find the camera centre
    [~, ~, V] = svd(P);
    c = V(1:3, end) / V(end, end);
    
    % Extract the rotation and intrinsic matrices using QR decomposition
    Rs = flipud(P(:, 1:3))';
    [Q, R] = qr(Rs);
    K = rot90(R', 2);
    R = flipud(Q');
	
    % Compute the translation vector t
    t = -R * c;
end