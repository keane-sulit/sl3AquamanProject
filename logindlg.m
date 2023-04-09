function success = logindlg(username, password)
    % Check if username is in accounts file
    accountsFile = 'accounts.txt';
    accounts = readAccounts(accountsFile);
    if ~isfield(accounts, username)
        errordlg('Username not found. Please register first.', 'Invalid Username');
        username = '';
        password = '';
        return;
    end

    % Check if password matches with username in accounts file
    if ~strcmp(accounts.(username), password)
        errordlg('Incorrect password.', 'Invalid Password');
        username = '';
        password = '';
        return;
    end
    % Display success prompt
    msgbox('Login successful!', 'Success');
    success = 1;
    return 
end