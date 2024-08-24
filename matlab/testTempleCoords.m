% A test script using templeCoords.mat

img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');
load('../data/someCorresp.mat');

% Compute the fundamental matrix
F = eightpoint(pts1, pts2, max(size(img1)));
disp(F);
displayEpipolarF(img1, img2, F);
figure;

% Load temple coordinates and find corresponding points in the second image
load('../data/templeCoords.mat');
pts2 = zeros(size(pts1, 1), 2);
for i = 1:size(pts1, 1)
    pred = epipolarCorrespondence(img1, img2, F, pts1(i, :));
    pts2(i, 1) = pred(1);
    pts2(i, 2) = pred(2);
end
epipolarMatchGUI(img1, img2, F);
figure;

% Load intrinsic parameters and compute the essential matrix
load('../data/intrinsics.mat');
E = essentialMatrix(F, K1, K2);

% Compute the camera matrices and triangulate points
P1 = [eye(3), zeros(3, 1)];
P2 = camera2(E);

for i = 1:4
    Ptry = triangulate(K1 * P1, pts1, K2 * P2(:, :, i), pts2);
    if all(Ptry(:, 3) > 0)
        pts3d = Ptry;
        M2 = P2(:, :, i);
        break;
    end
end

% Plot the 3D points
plot3(pts3d(:, 1), pts3d(:, 2), pts3d(:, 3), '--.','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF','LineStyle','none');
axis equal;

% Extract rotation and translation components from the camera matrices
R1 = P1(:, 1:3);
t1 = P1(:, 4);
R2 = M2(:, 1:3);
t2 = M2(:, 4);

% Save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');