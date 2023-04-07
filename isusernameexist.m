function exist = isusernameexist(username)
    exist = false;
    
    % Open accounts file
    try
        fileID = fopen('accounts.txt', 'r');
    catch ME
        errordlg(['Error opening file: ' ME.message], 'Error');
        return;
    end
    
    % Read file line by line and check if username exists
    while ~feof(fileID)
        line = fgetl(fileID);
        
        if isempty(line)
            continue;
        end
        
        % Extract username from line
        [saved_username, ~] = strtok(line, ',');
        
        % Check if usernames match
        if strcmpi(saved_username, username)
            exist = true;
            break;
        end
    end
    
    fclose(fileID);
end