openfemm(1);
opendocument('Rotor_0deg.FEM');

theta_init = 0; % fist angular increment
d_theta = 1; % angular rotation increment
baseFileName = 'Rotor_theta';
fileExtension = '.fem';


% define block
% add material
mi_getmaterial('Air') 
mi_getmaterial('M-15 Steel')
mi_getmaterial('20 AWG')
mi_getmaterial('Aluminum, 6061-T6')
% add block
% rotor segment --> to rotate with rotor
mi_addblocklabel(7.9,8);
mi_selectlabel(7.9,8);
mi_addblocklabel(7.9,-8);
mi_selectlabel(7.9,-8);
mi_addblocklabel(-7.9,8);
mi_selectlabel(-7.9,8);
mi_addblocklabel(-7.9,-8);
mi_selectlabel(-7.9,-8);
mi_setblockprop('M-15 Steel', 0, 0, '', 0, 1,1);
mi_clearselected;
% air --> to rotate with rotor
mi_addblocklabel(10,0);
mi_selectlabel(10,0);
mi_addblocklabel(-10,0);
mi_selectlabel(-10,0);
mi_addblocklabel(0,10);
mi_selectlabel(0,10);
mi_addblocklabel(0,-10);
mi_selectlabel(0,-10);
mi_setblockprop('Air', 0, 0, '', 0, 1,1);
mi_clearselected;

for theta = theta_init : d_theta : 90

% select all rotor points
mi_selectrectangle(-20,-20,20,20)
mi_selectgroup(1);
mi_moverotate(0,0,d_theta);

% rotate block by group 

currentFileTheta = [baseFileName num2str(theta) fileExtension];
mi_saveas(currentFileTheta);

mi_savebitmap('C:\Users\Lenovo\Desktop\fig')

end

main_restore
mi_zoomnatural