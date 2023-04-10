classdef main < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure        matlab.ui.Figure
        ExitAppButton   matlab.ui.control.Button
        Label           matlab.ui.control.Label
        Password        matlab.ui.control.TextArea
        PasswordLabel   matlab.ui.control.Label
        Username        matlab.ui.control.TextArea
        UserLabel       matlab.ui.control.Label
        RegisterButton  matlab.ui.control.Button
        SignInButton    matlab.ui.control.Button
    end

    
    properties (Access = private)
        user char
        pass char
    end
    
    methods (Access = private)
        
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: RegisterButton
        function RegisterButtonPushed(app, event)
            if isempty(app.user)&&isempty(app.pass)
                errordlg('No Input');
                return
            elseif isempty(app.user)
                errordlg('No Username Input');
                return
            elseif isempty(app.pass)
                errordlg('No Password Input');
                return
            else
                registerdlg(app.user, app.pass);
                return 
            end
        end

        % Value changed function: Username
        function UsernameValueChanged(app, event)
            app.user = char(app.Username.Value);
        end

        % Value changed function: Password
        function PasswordValueChanged(app, event)
            app.pass = char(app.Password.Value);
        end

        % Button pushed function: SignInButton
        function SignInButtonPushed(app, event)
            if isempty(app.user)&&isempty(app.pass)
                errordlg('No Input');
                return
            elseif isempty(app.user)
                errordlg('No Username Input');
                return
            elseif isempty(app.pass)
                errordlg('No Password Input');
                return
            else
                success = logindlg(app.user, app.pass);
                if success == 1
                    steg_exported(app, app.user);
                    app.delete;
                end
                return 
            end
        end

        % Button pushed function: ExitAppButton
        function ExitAppButtonPushed(app, event)
            app.delete;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create SignInButton
            app.SignInButton = uibutton(app.UIFigure, 'push');
            app.SignInButton.ButtonPushedFcn = createCallbackFcn(app, @SignInButtonPushed, true);
            app.SignInButton.IconAlignment = 'center';
            app.SignInButton.FontName = 'Avenir Next';
            app.SignInButton.Position = [262 204 113 39];
            app.SignInButton.Text = 'Sign In';

            % Create RegisterButton
            app.RegisterButton = uibutton(app.UIFigure, 'push');
            app.RegisterButton.ButtonPushedFcn = createCallbackFcn(app, @RegisterButtonPushed, true);
            app.RegisterButton.IconAlignment = 'center';
            app.RegisterButton.FontName = 'Avenir Next';
            app.RegisterButton.Position = [262 153 113 39];
            app.RegisterButton.Text = 'Register';

            % Create UserLabel
            app.UserLabel = uilabel(app.UIFigure);
            app.UserLabel.HorizontalAlignment = 'right';
            app.UserLabel.FontName = 'Avenir';
            app.UserLabel.Position = [205 304 61 22];
            app.UserLabel.Text = 'Username';

            % Create Username
            app.Username = uitextarea(app.UIFigure);
            app.Username.ValueChangedFcn = createCallbackFcn(app, @UsernameValueChanged, true);
            app.Username.FontName = 'Avenir';
            app.Username.Position = [281 304 150 24];

            % Create PasswordLabel
            app.PasswordLabel = uilabel(app.UIFigure);
            app.PasswordLabel.HorizontalAlignment = 'right';
            app.PasswordLabel.FontName = 'Avenir';
            app.PasswordLabel.Position = [207 270 59 22];
            app.PasswordLabel.Text = 'Password';

            % Create Password
            app.Password = uitextarea(app.UIFigure);
            app.Password.ValueChangedFcn = createCallbackFcn(app, @PasswordValueChanged, true);
            app.Password.FontName = 'Avenir';
            app.Password.Position = [281 270 150 24];

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.FontName = 'Avenir';
            app.Label.FontSize = 16;
            app.Label.Position = [49 359 544 22];
            app.Label.Text = 'A Steganographic Text Encryption and Decryption Application in MATLAB';

            % Create ExitAppButton
            app.ExitAppButton = uibutton(app.UIFigure, 'push');
            app.ExitAppButton.ButtonPushedFcn = createCallbackFcn(app, @ExitAppButtonPushed, true);
            app.ExitAppButton.IconAlignment = 'center';
            app.ExitAppButton.FontName = 'Avenir Next';
            app.ExitAppButton.Position = [263 102 113 39];
            app.ExitAppButton.Text = 'Exit App';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = main

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end