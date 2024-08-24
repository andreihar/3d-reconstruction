function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
    % epipolarCorrespondence:
    %   Args:
    %       im1:    Image 1
    %       im2:    Image 2
    %       F:      Fundamental Matrix from im1 to im2
    %       pts1:   coordinates of points in image 1
    %   Returns:
    %       pts2:   coordinates of points in image 2
    %

    % Compute the epipolar line in image 2
    l = F * [pts1(1) pts1(2) 1]';
    l = l / l(2);
    x = round(cross(l, [-l(2); l(1); l(2) * pts1(1) - l(1) * pts1(1)]));

    % Define the search window size and stride
    w = 15;
    stride = 5;

    % Extract the patch around the point in image 1
    patch1 = double(im1(pts1(2) - w : pts1(2) + w, pts1(1) - w : pts1(1) + w));

    % Initialise the best error to a large value
    bestError = Inf;

    % Define the Gaussian filter
    gaussianFilter = fspecial('gaussian', 2 * w + 1, 5);

    for i = x(1) - stride:x(1) + stride
        for j = x(2) - stride:x(2) + stride
            patch2 = double(im2(j - w : j + w, i - w : i + w));
            error = norm(gaussianFilter .* (patch1 - patch2), 'fro');
            if error < bestError
                bestError = error;
                pts2 = [i, j];
            end
        end
    end
end