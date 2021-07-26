%{
Rafet KAVAK - 2166783
EE374 - Electrical Equipment and Applications
Term Project Phase 3
%}
function [A_m, B_m, C_m, D_m, A_l, B_l, C_l, D_l, length] = e216678_kavak(text_path, library_path)
    %% Phase 1
    % Scanning the text file
    fileID = fopen(text_path);
    C = textscan(fileID, '%s %f %s %f %s %f %s %f %s %s %s %f %f %s %f %f %s %f %f %s %f %f %s %f %f %s %f %f', 'Delimiter', '\n');
    fclose(fileID);
    
    % Scanning the library file
    fileID2 = fopen(library_path);
    M = textscan(fileID2, '%s %s %s %s %s %s %s %s', 'Delimiter', ',');
    fclose(fileID2);
    
    sum = 0;
    sum2 = 0;
    line_type = char(C{10});

    % Checking the conductor name
    for i=2:16
        sum = sum + strcmp(line_type, M{1}{i});
    end
    % If the conductor name is not true, the code gives a warning.
    if sum==0
        fprintf('Conductor name is not valid.\n')
        fprintf('Enter one of the following types.\n')
        fprintf('Waxwing, Ostrich, Linnet, Ibis, Hawk, Dove, Rook, Drake, Rail, Cardinal, Bluejay, Pheasant, Plover, Falcon, Bluebird\n')
        correction = "Enter correnct conductor name: ";
        line_type = input(correction, 's');
    end

    for j=2:16
        sum2 = sum2 + strcmp(line_type, M{1}{j});
    end
    % If the conductor name is true, necessary information will be extracted.
    if sum2==1
        Ncircuit = C{2};
        Nbundle = C{4};
        dbundle = C{6};
        length = C{8}*1000;

        D1_AB = sqrt((C{12} - C{15})^2 + (C{13} - C{16})^2);
        D1_AC = sqrt((C{12} - C{18})^2 + (C{13} - C{19})^2);
        D1_BC = sqrt((C{15} - C{18})^2 + (C{16} - C{19})^2);

        if Ncircuit == 2
            D2_AB = sqrt((C{21} - C{24})^2 + (C{22} - C{25})^2);
            D2_AC = sqrt((C{21} - C{27})^2 + (C{22} - C{28})^2);
            D2_BC = sqrt((C{24} - C{27})^2 + (C{25} - C{28})^2);
        else
            D2_AB = -1;
            D2_AC = -1;
            D2_BC = -1; 
        end    
    end

    %% Phase 2
    f = 50; % Hz
    epsilon = 8.8541878176e-12;
    
    for k = 1:16
        if strcmp(line_type, M{1,1}{k,1})
            idx = k;
        end
    end
    
    % Series Resistance R (ohm/km)
    Resistance_s = str2double(M{1,7}{idx,1})/1.609344; % mile -> km
    Rbundle = Resistance_s/Nbundle;
    
    if Ncircuit == 2
        R = Rbundle/2;
    else
        R = Rbundle;
    end
    
    % Series Reactance X (ohm/km)
    GMR_s = str2double(M{1,8}{idx,1})*0.3048; % feet -> meter
    
    if Nbundle == 1
        GMRbundle = GMR_s;
    elseif Nbundle == 2
        GMRbundle = sqrt(GMR_s*dbundle);
    elseif Nbundle == 3
        GMRbundle = nthroot(GMR_s*dbundle^2,3);
    elseif Nbundle == 4
        GMRbundle = nthroot((GMR_s*dbundle^3)*sqrt(2),4);    
    elseif Nbundle == 5
        GMRbundle = nthroot(GMR_s*dbundle^4*((1+sqrt(5))/2)^2, 5);
    elseif Nbundle == 6
        GMRbundle = nthroot((6*GMR_s*dbundle^5),6);
    elseif Nbundle == 7
        GMRbundle = nthroot(GMR_s*dbundle^6*(2*cos(pi/7))^2*(1+2*cos(pi/7))^2, 7);
    elseif Nbundle == 8
        GMRbundle = nthroot(((2*sqrt(2+sqrt(2)))*(2*(1+sqrt(2)))*(sqrt(4+2*sqrt(2)))*GMR_s*dbundle^7),8);      
    else
        fprintf('Invalid bundle number.\n');
    end
    
    if Ncircuit == 1
        GMD = nthroot(D1_AB*D1_AC*D1_BC, 3);
        GMR = GMRbundle;
    else
        D_AB1 = sqrt((C{24}-C{12})^2+(C{25}-C{13})^2);
        D_AB2 = sqrt((C{15}-C{21})^2+(C{16}-C{22})^2);      
        D_BC1 = sqrt((C{27}-C{12})^2+(C{28}-C{13})^2);
        D_BC2 = sqrt((C{18}-C{21})^2+(C{19}-C{22})^2);
        D_AC1 = sqrt((C{27}-C{15})^2+(C{28}-C{16})^2);
        D_AC2 = sqrt((C{18}-C{24})^2+(C{19}-C{25})^2);
        
        D_AB = nthroot(D1_AB*D2_AB*D_AB1*D_AB2, 4);
        D_BC = nthroot(D1_BC*D2_BC*D_BC1*D_BC2, 4);   
        D_AC = nthroot(D1_AC*D2_AC*D_AC1*D_AC2, 4);
    
        GMD = nthroot(D_AB*D_AC*D_BC, 3);
        
        % New GMR
        D_AA = sqrt((C{21}-C{12})^2+(C{22}-C{13})^2);
        D_BB = sqrt((C{24}-C{15})^2+(C{25}-C{16})^2);
        D_CC = sqrt((C{27}-C{18})^2+(C{28}-C{19})^2);
        
        GMR_A = sqrt(GMRbundle*D_AA);
        GMR_B = sqrt(GMRbundle*D_BB);
        GMR_C = sqrt(GMRbundle*D_CC);
        
        GMR = nthroot(GMR_A*GMR_B*GMR_C, 3);
    end
    
    L = 2e-7*log(GMD/GMR); % H/m per phase
    
    X = 2*pi*f*L*1000;
    
    
    % Shunt Susceptance B (mho/km)
    Radius_s = (str2double(M{1,5}{idx,1})/2)*0.0254; % inch -> meter
    
    if Nbundle == 1
        Rbundle = Radius_s;
    elseif Nbundle == 2
        Rbundle = sqrt(Radius_s*dbundle);
    elseif Nbundle == 3
        Rbundle = nthroot(Radius_s*dbundle^2,3);
    elseif Nbundle == 4
        Rbundle = nthroot((Radius_s*dbundle^3)*sqrt(2),4);    
    elseif Nbundle == 5
        Rbundle = nthroot(Radius_s*dbundle^4*((1+sqrt(5))/2)^2, 5);
    elseif Nbundle == 6
        Rbundle = nthroot((6*Radius_s*dbundle^5),6);
    elseif Nbundle == 7
        Rbundle = nthroot(Radius_s*dbundle^6*(2*cos(pi/7))^2*(1+2*cos(pi/7))^2, 7);
    elseif Nbundle == 8
        Rbundle = nthroot(((2*sqrt(2+sqrt(2)))*(2*(1+sqrt(2)))*(sqrt(4+2*sqrt(2)))*Radius_s*dbundle^7),8);        
    else
        fprintf('Invalid bundle number.\n');
    end    
    
    if Ncircuit == 1
        r_eq = Rbundle;
        
        H1_1 = C{13}*2;
        H2_1 = C{16}*2;
        H3_1 = C{19}*2;

        H12_1 = sqrt((C{15}-C{12})^2+(C{16}+C{13})^2);
        H23_1 = sqrt((C{18}-C{15})^2+(C{19}+C{16})^2);
        H31_1 = sqrt((C{18}-C{12})^2+(C{19}+C{13})^2);
        
        C = 2*pi*epsilon/(log(GMD/r_eq)-log(nthroot((H12_1*H23_1*H31_1)/(H1_1*H2_1*H3_1),3)));
    else
        r_eq_1 = sqrt(Rbundle*D_AA);
        r_eq_2 = sqrt(Rbundle*D_BB);
        r_eq_3 = sqrt(Rbundle*D_CC);
        
        r_eq = nthroot(r_eq_1*r_eq_2*r_eq_3, 3);
        
        H1_1 = C{13}*2;
        H2_1 = C{16}*2;
        H3_1 = C{19}*2;
        
        H12_1 = sqrt((C{15}-C{12})^2+(C{16}+C{13})^2);
        H23_1 = sqrt((C{18}-C{15})^2+(C{19}+C{16})^2);
        H31_1 = sqrt((C{18}-C{12})^2+(C{19}+C{13})^2); 
        
        H1_2 = C{22}*2;
        H2_2 = C{25}*2;
        H3_2 = C{28}*2;
        
        H11_2 = sqrt((C{21}-C{12})^2+(C{22}+C{13})^2);
        H22_2 = sqrt((C{24}-C{15})^2+(C{25}+C{16})^2);
        H33_2 = sqrt((C{27}-C{18})^2+(C{28}+C{19})^2);
        
        H1_1_2 = nthroot(H11_2^2*H1_1*H1_2, 4);
        H2_1_2 = nthroot(H22_2^2*H2_1*H2_2, 4);
        H3_1_2 = nthroot(H33_2^2*H3_1*H3_2, 4);

        H12_2 = sqrt((C{24}-C{21})^2+(C{25}+C{22})^2);
        H23_2 = sqrt((C{27}-C{24})^2+(C{28}+C{25})^2);
        H31_2 = sqrt((C{27}-C{21})^2+(C{28}+C{22})^2);
        
        H12_2_1 = sqrt((C{24}-C{12})^2+(C{25}+C{13})^2);
        H23_2_1 = sqrt((C{27}-C{15})^2+(C{28}+C{16})^2);
        H31_2_1 = sqrt((C{27}-C{12})^2+(C{28}+C{13})^2);       
        
        H12_2_2 = sqrt((C{15}-C{21})^2+(C{16}+C{22})^2);
        H23_2_2 = sqrt((C{18}-C{24})^2+(C{19}+C{25})^2);
        H31_2_2 = sqrt((C{18}-C{21})^2+(C{19}+C{22})^2);
        
        H12_1_2 = nthroot(H12_1*H12_2_1*H12_2_2*H12_2, 4);
        H23_1_2 = nthroot(H23_1*H23_2_1*H23_2_2*H23_2, 4);
        H31_1_2 = nthroot(H31_1*H31_2_1*H31_2_2*H31_2, 4);
        
        C = 2*pi*epsilon/(log(GMD/r_eq)-log(nthroot((H12_1_2*H23_1_2*H31_1_2)/(H1_1_2*H2_1_2*H3_1_2),3)));
    end
    
    
    B = 2*pi*f*C*1000;
    
    % Bonus Part
    X_bonus = -1;
    B_bonus = -1;
    
    %% Phase 3
    z = R+X*1i;
    y = B*1i;

    Z = z*length/1000;
    Y = y*length/1000;

    Z_0 = sqrt(z/y);
    gamma = sqrt(z*y);
    
    % Medium Line Model
    A_m = 1+Z*Y/2;
    B_m = Z;
    C_m = Y*(1+Z*Y/4);
    D_m = 1+Z*Y/2;
    
    % Long Line Model
    A_l = cosh(gamma*length/1000);
    B_l = Z_0*sinh(gamma*length/1000);
    C_l = sinh(gamma*length/1000)/Z_0;
    D_l = cosh(gamma*length/1000);
    
end
