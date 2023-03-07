function imgwmessage = steg_encrypt(img, message)
% Convert image to binary
imgbinary = str2double(reshape(cellstr(dec2bin(img)), size(img)));

% Convert message to binary
inputascii = double(message);
shiftascii = inputascii + 3;
binary = reshape(dec2bin(shiftascii, 8).'-'0',1,[]);
dash = [0 0 1 0 1 1 0 1];

% Embed message in image
[maxrows, maxcolumns, maxpages] = size(img);
binarywdash = [binary dash dash dash];
counter = 1; rows = 1; columns = 1; page = 1;
while counter < (length(binarywdash)+1)
    if mod(double(img(rows,columns,page)), 2) < binarywdash(1,counter)
        imgbinary(rows,columns,page) = imgbinary(rows,columns,page) + 1;
    elseif mod(double(img(rows,columns,page)), 2) > binarywdash(1,counter)
        imgbinary(rows,columns,page) = imgbinary(rows,columns,page) - 1;
    end
    page = page + 1;
    if page == 4
        columns = columns + 1;
        page = 1;
    end
    if columns == maxcolumns + 1
        rows = rows + 1;
        columns = 1;
    end
    counter = counter + 1;
end

% Convert binary image back to decimal and save
imgwmessage = uint8(bin2dec(string(imgbinary(:,:,:))));
end