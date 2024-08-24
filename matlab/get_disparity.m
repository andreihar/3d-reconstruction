function dispM = get_disparity(im1, im2, maxDisp, windowSize)
    % Create a disparity map from a pair of rectified images im1 and im2,
    % given the maximum disparity maxDisp and the window size windowSize.
    
    % Create a mask for convolution
    mask = ones(windowSize);
    
    % Get the size of the input images
    [rows, cols] = size(im1);
    
    % Initialise the distance and sum matrices
    dist = zeros(rows, cols, maxDisp + 1);
    sumDiff = zeros(rows, cols);
    
    % Compute the disparity map
    for d = 0:maxDisp
        % Compute the squared differences for the current disparity
        sumDiff(1:(rows * (cols - d))) = (im1((1:(rows * (cols - d))) + rows * d) - im2(1:(rows * (cols - d)))).^2;
        
        % Convolve the squared differences with the mask
        dist(:, :, d + 1) = conv2(sumDiff, mask, 'same');
    end
    
    % Find the disparity with the minimum distance
    [~, minIndex] = min(dist, [], 3);
    
    % Create the disparity map
    dispM = minIndex - 1;
end