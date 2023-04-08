function registerdlg(username, password)

    % Check if username is already taken
    if isusernameexist(username)
        errordlg('Username already exists.', 'Error');
        return;
    end
    
    % Check password length
    if length(password) < 8
        errordlg('Password must be at least 8 characters long.', 'Invalid Password');
        return;
    end
    
    % Check password strength
    if ~any(isstrprop(password, 'upper')) || ~any(isstrprop(password, 'lower')) || ~any(isstrprop(password, 'digit'))
        errordlg('Password must contain at least one uppercase letter, one lowercase letter, and one digit.', 'Invalid Password');
        return;
    end
    
    % Write username and hashed password to file
    try
        fileID = fopen('accounts.txt', 'a');
        fprintf(fileID, '%s,%s\n', username, password);
        fclose(fileID);
        msgbox('User registered successfully!', 'Success');
    catch ME
        errordlg(['Error writing to file: ' ME.message], 'Error');
    end
end