function [coordsIM1, coordsIM2] = epipolarMatchGUI(I1, I2, F)
    % epipolarMatchGUI:
    %   Args:
    %       I1: Image 1
    %       I2: Image 2
    %       F:  Fundamental Matrix from I1 to I2
    %   Returns:
    %       coordsIM1: Coordinates of points in image 1
    %       coordsIM2: Corresponding coordinates of points in image 2

    coordsIM1 = [];
    coordsIM2 = [];
    [sy, sx] = size(I2);

    % Display the images
    figure(gcf), clf
    h_axes1 = subplot(121);
    imshow(I1, []); hold on
    xlabel({'Select a point in this image', '(Right-click when finished)'})

    subplot(122)
    imshow(I2, []);
    xlabel({'Verify that the corresponding point', 'is on the epipolar line in this image'})

    while true
        subplot(121)
        [x, y, button] = ginput(1);
        if button == 3  % Right-click to finish
            break;
        end
        if gca ~= h_axes1
            subplot(121)
            title('Please click only in this image')
            continue;
        else
            subplot(121)
            title('')
        end

        % Compute the epipolar line in image 2
        v = [x; y; 1];
        l = F * v;
        s = sqrt(l(1)^2 + l(2)^2);

        if s == 0
            error('Zero line vector in displayEpipolar');
        end

        l = l / s;

        % Plot the selected point in image 1
        plot(x, y, '*', 'MarkerSize', 10, 'LineWidth', 2);

        % Plot the epipolar line in image 2
        subplot(122)

        % Compute the endpoints of the epipolar line
        if l(1) ~= 0
            ys = 1; ye = sy; xs = -(l(2) * ys + l(3)) / l(1); xe = -(l(2) * ye + l(3)) / l(1);
        else
            xs = 1; xe = sx; ys = -(l(1) * xs + l(3)) / l(2); ye = -(l(1) * xe + l(3)) / l(2);
        end
        line([xs xe], [ys ye], 'linewidth', 2);
        hold on;

        % Find the corresponding point in image 2
        [pts] = epipolarCorrespondence(I1, I2, F, [x, y]);
        x2 = pts(1);
        y2 = pts(2);
        plot(x2, y2, 'ro', 'MarkerSize', 8, 'LineWidth', 3);

        % Store the coordinates
        coordsIM1 = [coordsIM1; x, y];
        coordsIM2 = [coordsIM2; x2, y2];
    end

    subplot(121), hold off
end