function [xMin, xMax, imageBitmap] = DDBTC_Encode(inputImage, blockSizeX, blockSizeY, classMatrix, diffusedMatrix);
inputImage = double(inputImage);
[row, col] = size(inputImage);

numberOfBlockX = row / blockSizeX;
numberOfBlockY = col / blockSizeY;

inputImage = mat2cell(inputImage, blockSizeX*ones(1, numberOfBlockX), blockSizeY*ones(1, numberOfBlockY));
imageBitmap = zeros(row, col);
imageBitmap = mat2cell(imageBitmap, blockSizeX*ones(1, numberOfBlockX), blockSizeY*ones(1, numberOfBlockY));
xMin = zeros(numberOfBlockX, numberOfBlockY);
xMax = zeros(numberOfBlockX, numberOfBlockY);

for i=1: numberOfBlockX
    for j=1: numberOfBlockY
        pixel = inputImage{i, j};
        [xMin(i, j), xMax(i, j), imageBitmap{i, j}] = PerformErrorDiffusionHalftoning(pixel, classMatrix, diffusedMatrix);
    end;
end;

imageBitmap = cell2mat(imageBitmap);


function [xMin, xMax, imageBitmap] = PerformErrorDiffusionHalftoning(pixel, classMatrix, diffusedMatrix);
[row, col] = size(pixel);
[classMatrixSizeX, classMatrixSizeY] = size(classMatrix);

xMin = min(pixel(:)); 
xMax = max(pixel(:)); 
xMean = mean(pixel(:));

r = 1;
x = padarray(pixel, [r r], 'symmetric');
paddedClassMatrix = padarray(classMatrix, [r r], 'symmetric');

imageBitmap = zeros(row, col);

for processingOrder = 0: classMatrixSizeX*classMatrixSizeY-1
    [positionOrderX, positionOrderY] = find(classMatrix == processingOrder);
            
    if x(positionOrderX+r, positionOrderY+r) < xMean
        imageBitmap(positionOrderX, positionOrderY) = 0;
        o = xMin;
    else
        imageBitmap(positionOrderX, positionOrderY) = 1;
        o = xMax;
    end;
            
    e = x(positionOrderX+r, positionOrderY+r) - o;
    unProcessedPixel = (paddedClassMatrix(positionOrderX+r-r: positionOrderX+r+r, positionOrderY+r-r: positionOrderY+r+r) >= processingOrder);
    x(positionOrderX+r-r: positionOrderX+r+r, positionOrderY+r-r: positionOrderY+r+r) = x(positionOrderX+r-r: positionOrderX+r+r, positionOrderY+r-r: positionOrderY+r+r) + e*(unProcessedPixel.*diffusedMatrix)/sum(sum(unProcessedPixel.*diffusedMatrix));
end;