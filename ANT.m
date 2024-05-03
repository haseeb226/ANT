%% Attention Network Task
%Implementted in MATLAB using PsychToolBox-3
%alphabets "A" and "L" are used to make a response
%if your keyboard has different keycodes then those can be replaced.
%Currently, "A" = 65; "L" = 76
%you would have to replace corresponding numbers in practice and...
%...actual tasks

%% Main program starts here
function ANT()
    %Load existing data file if it exists
    filename = 'experiment_ANT_data.mat';
    if exist(filename, 'file')
        load(filename, 'ANT_Data');
    else
        ANT_Data = struct('ParticipantID', {}, 'Gender', {}, 'ANT_block', {});
    end
    
    % Prompt the user to input the participant ID
    participantID = input('Enter Participant ID: ', 's');
    
    % Check if the participant ID already exists in any of the datasets
    while isParticipantIDInUse(ANT_Data, participantID)
        disp('Participant ID is already in use. Please enter a different ID.');
        participantID = input('Enter Participant ID: ', 's');
    end
    
    % Prompt the user to input the participant's gender
    genderOptions = {'male', 'female', 'non-binary'};
    gender = input('Enter Participant Gender (0 for male, 1 for female, 2 for non-binary): ');
    while ~ismember(gender, [0, 1, 2])
        disp('Invalid input. Please enter 0 for male, 1 for female, or 2 for non-binary.');
        gender = input('Enter Participant Gender (0 for male, 1 for female, 2 for non-binary): ');
    end
    % enter data for leg 3
    ANT_Data(end+1).ParticipantID = participantID;
    ANT_Data(end).Gender = genderOptions{gender+1};
    %disable warnings
    Screen('Preference', 'Verbosity', 0);
    Screen('Preference', 'SkipSyncTests',1);
    Screen('Preference', 'VisualDebugLevel',0);
    %opening onscreen window
    windowPtr = Screen('OpenWindow',0);
    %screen text settings
    Screen('TextSize', windowPtr, 40);
    Screen('TextFont', windowPtr, 'Helvetica');
    Screen('TextStyle', windowPtr);

    %Introduction screen
    Screen('DrawText', windowPtr, 'Welcome!', 200, 100, [0 0 0]);
    Screen('DrawText', windowPtr, 'This is an experiment investigating attention.', 200, 165, [0 0 0]);
    Screen('DrawText', windowPtr, 'You will be shown an arrow on the screen pointing', 200, 230, [0 0 0]);
    Screen('DrawText', windowPtr, '   either to the left or to the right (for example < or > ).,', 200, 295, [0 0 0]);
    Screen('DrawText', windowPtr, 'On some trials, the arrow will be flanked by two arrows to the left and two arrows to the right', 200, 360, [0 0 0]);
    Screen('DrawText', windowPtr, '   For example: ( > > > > >, or > > < > >).', 200, 425, [0 0 0]);
    Screen('DrawText', windowPtr, 'Your task is to respond to the direction of the CENTRAL arrow.', 200, 490, [0 0 0]);
    Screen('DrawText', windowPtr, 'You should press ‘A’ if the central arrow points towards left and', 200, 555, [0 0 0]);
    Screen('DrawText', windowPtr, '   you should press ‘L’ if the central arrow points towards right.', 200, 620, [0 0 0]);
    Screen('DrawText', windowPtr, 'Please make your response as quickly and accurately as possible.', 200, 685, [0 0 0]);
    Screen('DrawText', windowPtr, 'our reaction time and accuracy will be recorded.', 200, 750, [0 0 0]);
    Screen('DrawText', windowPtr, '(Press any key to continue to further instructions)', 800, 999, [0 0 0]);
    Screen('Flip', windowPtr);
    KbPressWait();
    %Introduction screen 2
    Screen('DrawText', windowPtr, 'There will be a cross ("+") in the center of the screen', 200, 100, [0 0 0]);
    Screen('DrawText', windowPtr, '   and the arrows will appear either above or below the cross.', 200, 165, [0 0 0]);
    Screen('DrawText', windowPtr, 'You should try to fixate on the cross throughout the experiment.', 200, 230, [0 0 0]);
    Screen('DrawText', windowPtr, 'On some trials there will be asterisk cues indicating when or where the arrow will occur.', 200, 295, [0 0 0]);
    Screen('DrawText', windowPtr, 'If the cue is at the center or both above and below fixation', 200, 360, [0 0 0]);
    Screen('DrawText', windowPtr, '   it indicates that the arrow will appear shortly.', 200, 425, [0 0 0]);
    Screen('DrawText', windowPtr, 'If the cue is only above or below fixation it indicates', 200, 490, [0 0 0]);
    Screen('DrawText', windowPtr, '   both that the trial will occur shortly and where it will occur.', 200, 555, [0 0 0]);
    Screen('DrawText', windowPtr, 'Try to maintain fixation at all times.', 200, 620, [0 0 0]);
    Screen('DrawText', windowPtr, 'However, you may attend when and where indicated by the cues.', 200, 685, [0 0 0]);
    Screen('DrawText', windowPtr, '(Press any key to continue to further instructions)', 800, 999, [0 0 0]);
    Screen('Flip', windowPtr);
    KbPressWait();
    %Introduction screen 3
    Screen('DrawText', windowPtr, 'The experiment contains four blocks.', 800, 100, [0 0 0]);
    Screen('DrawText', windowPtr, 'The first block is for practice,', 200, 300, [0 0 0]);
    Screen('DrawText', windowPtr, '   the other three blocks are experimental blocks.', 200, 400, [0 0 0]);
    Screen('DrawText', windowPtr, 'After each block there will be a message "take a break" and you may take a short rest.', 200, 500, [0 0 0]);
    Screen('DrawText', windowPtr, 'After it, you can press the space bar to begin the next block.', 200, 600, [0 0 0]);
    Screen('DrawText', windowPtr, '(Press any key to continue to the practice block)', 800, 999, [0 0 0]);
    Screen('Flip', windowPtr);
    KbPressWait();
    %practice screen
    Screen('DrawText', windowPtr, 'Keep your left index finger on "A", and right index finger on "L".', 200, 100, [0 0 0]);
    Screen('DrawText', windowPtr, 'Try to fixate on the +', 200, 200, [0 0 0]);
    Screen('DrawText', windowPtr, 'The trails will begin in few seconds.', 200, 300, [0 0 0]);
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('Flip', windowPtr);
    WaitSecs(5);
    %key restriction
    KbName('UnifyKeyNames'); % use internal naming to support multiple platforms
    ans_accept = 'al';
    keynames = mat2cell(ans_accept, 1, ones(length(ans_accept), 1));
    RestrictKeysForKbCheck(KbName(keynames));
    %practice tasks
    Screen('TextSize', windowPtr, 70);
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(1.2)
    %practice task 1
    Screen('TextSize', windowPtr, 70);
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('DrawText', windowPtr, '*', 925, 400, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(0.1)
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(0.4)
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('TextSize', windowPtr, 50);
    Screen('DrawText', windowPtr, '< < > < <', 835, 400, [0 0 0])
    Screen('Flip', windowPtr)
    [~, keycode] = KbWait(); % wait until specific key press
    keycode = KbName(keycode); % convert from key code to char
    pract_resp = KbName(keycode);
    if pract_resp == 76
        pract_text = 'Correct!';
    else
        pract_text = 'Incorrect!';
    end
    %practice task1 feedback
    Screen('DrawText', windowPtr, pract_text, 800, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(1)
    %practice task2
    Screen('TextSize', windowPtr, 70);
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(1)
    Screen('TextSize', windowPtr, 70);
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('DrawText', windowPtr, '*', 925, 400, [0 0 0])
    Screen('DrawText', windowPtr, '*', 925, 600, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(0.1)
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(0.4)
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('TextSize', windowPtr, 50);
    Screen('DrawText', windowPtr, '< < < < <', 835, 400, [0 0 0])
    Screen('Flip', windowPtr)
    [~, keycode] = KbWait(); % wait until specific key press
    keycode = KbName(keycode); % convert from key code to char
    pract_resp = KbName(keycode);
    if pract_resp == 65
        pract_text = 'Correct!';
    else
        pract_text = 'Incorrect!';
    end
    %practice task2 feedback
    Screen('DrawText', windowPtr, pract_text, 800, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(1)
    %practice task3
    Screen('TextSize', windowPtr, 70);
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(1.2)
    Screen('TextSize', windowPtr, 70);
    Screen('DrawText', windowPtr, '*', 925, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(0.1)
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(0.4)
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('TextSize', windowPtr, 50);
    Screen('DrawText', windowPtr, '< < > < <', 835, 400, [0 0 0])
    Screen('Flip', windowPtr)
    [~, keycode] = KbWait(); % wait until specific key press
    keycode = KbName(keycode); % convert from key code to char
    pract_resp = KbName(keycode);
    if pract_resp == 76
        pract_text = 'Correct!';
    else
        pract_text = 'Incorrect!';
    end
    %practice task3 feedback
    Screen('DrawText', windowPtr, pract_text, 800, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(1)
    %practice task4
    Screen('TextSize', windowPtr, 70);
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(1)
    Screen('TextSize', windowPtr, 70);
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(0.5)
    Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
    Screen('TextSize', windowPtr, 50);
    Screen('DrawText', windowPtr, '< < < < <', 835, 400, [0 0 0])
    Screen('Flip', windowPtr)
    [~, keycode] = KbWait(); % wait until specific key press
    keycode = KbName(keycode); % convert from key code to char
    pract_resp = KbName(keycode);
    if pract_resp == 65
        pract_text = 'Correct!';
    else
        pract_text = 'Incorrect!';
    end
    %practice task4 feedback
    Screen('DrawText', windowPtr, pract_text, 800, 500, [0 0 0])
    Screen('Flip', windowPtr)
    WaitSecs(1)

    WaitSecs(0.2)
    RestrictKeysForKbCheck([]); % re-enable all keys
    %block1 screen
    Screen('DrawText', windowPtr, 'Now there will be 3 blocks, each block takes 5 minutes', 200, 600, [0 0 0]);
    Screen('DrawText', windowPtr, '(To start block1 press any key, when you are ready!)', 200, 999, [0 0 0]);
    Screen('Flip', windowPtr);
    KbPressWait();

    %text variables loading
    text1 = '< < < < <';
    text2 = '> > > > >';
    text3 = '< < > < <';
    text4 = '> > < > >';
    text5 = '-  -  <  -  -';
    text6 = '-  -  >  -  -';

    % Generate pairs of random numbers
    Ran_1_range = 1:3;
    Ran_2_range = 1:4;

    for j = 1:3
        ANT_resp = cell(numel(Ran_1_range), numel(Ran_2_range));
        ANT_RT = cell(numel(Ran_1_range), numel(Ran_2_range));
        pair_frequency = zeros(numel(Ran_1_range), numel(Ran_2_range));
        total_pairs = 96;
        ms_400 = 0;
        ms_800 = 0;
        ms_1200 = 0;
        ms_1600 = 0;
        while total_pairs > 0
            % Generate random numbers within the specified ranges
            Ran_1 = randi(numel(Ran_1_range));
            Ran_2 = randi(numel(Ran_2_range));

            % Check if the pair frequency is less than 8
            if pair_frequency(Ran_1, Ran_2) < 8
                %select fixation presented time
                time_inx = 0;
                while time_inx == 0
                    ran_cue_time = randi(4);
                    if ran_cue_time == 1 && ms_400 < 24
                        cue_time = 0.4;
                        ms_400 = ms_400 + 1;
                        time_inx = 1;
                    elseif ran_cue_time == 2 && ms_800 < 24
                        cue_time = 0.8;
                        ms_800 = ms_800 + 1;
                        time_inx = 1;
                    elseif ran_cue_time == 3 && ms_1200 < 24
                        cue_time = 1.2;
                        ms_1200 = ms_1200 + 1;
                        time_inx = 1;
                    elseif ran_cue_time == 4 && ms_1600 < 24
                        cue_time = 1.6;
                        ms_1600 = ms_1600 + 1;
                        time_inx = 1;
                    end
                end
                % fixation screen between the trials
                Screen('TextSize', windowPtr, 70);
                Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                Screen('Flip', windowPtr)
                WaitSecs(cue_time)
                if Ran_1 == 1
                    ran_text = randi(2);
                    switch ran_text
                        case 1
                            selectedText = text1;
                        case 2
                            selectedText = text2;
                    end
                elseif Ran_1 == 2
                    ran_text = randi(2);
                    switch ran_text
                        case 1
                            selectedText = text3;
                        case 2
                            selectedText = text4;
                    end
                elseif Ran_1 == 3
                    ran_text = randi(2);
                    switch ran_text
                        case 1
                            selectedText = text5;
                        case 2
                            selectedText = text6;
                    end
                end
                ran_cue = randi(2);
                if Ran_2 == 1
                    switch ran_cue
                        case 1 %single cue above
                            Screen('TextSize', windowPtr, 70);
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('DrawText', windowPtr, '*', 925, 400, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.1)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.4)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('TextSize', windowPtr, 50);
                            Screen('DrawText', windowPtr, selectedText, 835, 400, [0 0 0])
                            Screen('Flip', windowPtr)
                        case 2 %single cue below
                            Screen('TextSize', windowPtr, 70);
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('DrawText', windowPtr, '*', 925, 600, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.1)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.4)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('TextSize', windowPtr, 50);
                            Screen('DrawText', windowPtr, selectedText, 835, 600, [0 0 0])
                            Screen('Flip', windowPtr)
                    end
                elseif Ran_2 == 2
                    switch ran_cue
                        case 1 %double cue above
                            Screen('TextSize', windowPtr, 70);
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('DrawText', windowPtr, '*', 925, 400, [0 0 0])
                            Screen('DrawText', windowPtr, '*', 925, 600, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.1)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.4)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('TextSize', windowPtr, 50);
                            Screen('DrawText', windowPtr, selectedText, 835, 400, [0 0 0])
                            Screen('Flip', windowPtr)
                        case 2 %double cue below
                            Screen('TextSize', windowPtr, 70);
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('DrawText', windowPtr, '*', 925, 400, [0 0 0])
                            Screen('DrawText', windowPtr, '*', 925, 600, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.1)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.4)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('TextSize', windowPtr, 50);
                            Screen('DrawText', windowPtr, selectedText, 835, 600, [0 0 0])
                            Screen('Flip', windowPtr)
                    end
                elseif Ran_2 == 3
                    switch ran_cue
                        case 1 %centre cue above
                            Screen('TextSize', windowPtr, 70);
                            Screen('DrawText', windowPtr, '*', 925, 500, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.1)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.4)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('TextSize', windowPtr, 50);
                            Screen('DrawText', windowPtr, selectedText, 835, 400, [0 0 0])
                            Screen('Flip', windowPtr)
                        case 2 %centre cue below
                            Screen('TextSize', windowPtr, 70);
                            Screen('DrawText', windowPtr, '*', 925, 500, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.1)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.4)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('TextSize', windowPtr, 50);
                            Screen('DrawText', windowPtr, selectedText, 835, 600, [0 0 0])
                            Screen('Flip', windowPtr)
                    end
                elseif Ran_2 == 4
                    switch ran_cue
                        case 1 % no cue above
                            Screen('TextSize', windowPtr, 70);
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.5)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('TextSize', windowPtr, 50);
                            Screen('DrawText', windowPtr, selectedText, 835, 400, [0 0 0])
                            Screen('Flip', windowPtr)
                        case 2 % no cue below
                            Screen('TextSize', windowPtr, 70);
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('Flip', windowPtr)
                            WaitSecs(0.5)
                            Screen('DrawText', windowPtr, '+', 920, 500, [0 0 0])
                            Screen('TextSize', windowPtr, 50);
                            Screen('DrawText', windowPtr, selectedText, 835, 600, [0 0 0])
                            Screen('Flip', windowPtr)
                    end
                end
                % Record stimulus presentation time
                stimulusOnsetTime = GetSecs();
                KbPressWait()
                % Record response time
                responseTime = GetSecs();
                % Calculate response time/reaction time
                reaction_time = responseTime - stimulusOnsetTime;
                %Check response
                KbName('UnifyKeyNames'); % use internal naming to support multiple platforms
                ans_accept = 'al';
                keynames = mat2cell(ans_accept, 1, ones(length(ans_accept), 1));
                RestrictKeysForKbCheck(KbName(keynames));
                [~, keycode] = KbWait(); % wait until specific key press
                keycode = KbName(keycode); % convert from key code to char
                response = KbName(keycode);
                %check for correct answer
                if (strcmp(selectedText, text1) || strcmp(selectedText, text4) || strcmp(selectedText, text5)) & response == 65
                    response_correct = 1;
                elseif (strcmp(selectedText, text2) || strcmp(selectedText, text3) || strcmp(selectedText, text6)) & response == 76
                    response_correct = 1;
                else
                    response_correct = 0;
                end
                ANT_resp{Ran_1, Ran_2} = [ANT_resp{Ran_1, Ran_2} response_correct];
                ANT_RT{Ran_1, Ran_2} = [ANT_RT{Ran_1, Ran_2} reaction_time];
                % Update pair frequency
                pair_frequency(Ran_1, Ran_2) = pair_frequency(Ran_1, Ran_2) + 1;
                % Decrease the count of remaining pairs
                total_pairs = total_pairs - 1;

            end
        end
        WaitSecs(0.2)
        RestrictKeysForKbCheck([]); % re-enable all keys

        if j < 3
            text = sprintf('block%d is complete\n', j);
            %end of block screen
            Screen('DrawText', windowPtr, text, 800, 100, [0 0 0]);
            Screen('DrawText', windowPtr, 'You may take a break now!', 200, 300, [0 0 0]);
            Screen('DrawText', windowPtr, 'Press any button when you are ready for the next block', 200, 600, [0 0 0]);
            Screen('Flip', windowPtr);
            KbPressWait();
        elseif j == 3
            Screen('DrawText', windowPtr, 'That the end of block3!', 500, 500, [0 0 0]);
            Screen('Flip', windowPtr);
            WaitSecs(2);
            sca
        end
        %block data entry
        ANT_Data(end).ANT_block{j, 1} = ANT_RT;
        ANT_Data(end).ANT_block{j, 2} = ANT_resp;
    end
    % Save leg data to .mat file
    save(filename, 'ANT_Data');
    
    disp('Data saved successfully.');
end

function inUse = isParticipantIDInUse(data, participantID)
% Check if the participant ID already exists in the dataset
inUse = any(strcmp({data.ParticipantID}, participantID));
end
