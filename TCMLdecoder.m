%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 TU Braunschweig - Raumfahrtsysteme Institut             %
%                http://www.space-systems.eu/index.php/de/                %
%                    Copyright IRAS - TUBS 2017-2018                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%            ToWrite = TCMLcoder(Input)
%
%  Input: Variable or Port COM to read
%    
%  Output: 6-element vector
%
%         Output = [ addr, comm, type, moto, values, flag]; 
%      addr: address of the comm-port (could be consulted using TMCL - IDE)
%      comm: Command number listed on TMCL^TM Firmware Manual 
%            (Is gotten in the numeric form)
%      type: Type number listed on TMCL^TM Firmware Manual 
%            (Is gotten in the numeric form)
%      motor: Motor or Bank number listed on TMCL^TM Firmware Manual 
%            (Is gotten in the numeric form)
%      values: Value number listed on TMCL^TM Firmware Manual 
%            (Is gotten in numeric form)
%      flag: Verifies CheckSum read. 
%            Flag = 1 means the sum is correct, thus data input is correct.
%            Flag = 0 means the incoming data could be corrupted.
%            
%           Further information could be consulted on:
%           TMCL^TM Firmware Manual TMCM-351 
%           available on http://www.trinamic.com
%
%   Description: 
%    This function allows to read Motor-Encoders getting a decimal data of 
%     drive boards Trinamic Motion Control GmbH & Co. KG.
%                      http://www.trinamic.com
%     Following "Binary command format" suggested for serial communication
%   (USB, RS232, RS485). This script also calculates checksum and verify if
%      the sent binary-word is correct.
%      This script is not intended for commercial propose.
%      Trinamic, TLML and TMCM-351 are registered and their rights owes
%      the respective owners.
%   
%   Tested on:
% Stepper Motor Controller TMCM-351 v1.1, Firmware v4.17 and Firmware v4.48
%    
%   Example:: 
%
%    % To move motor0 to the right during 1 sec, then to stop
%    Motor0 = serial('COM1');
%    fopen(Motor0);
% 
%    %        add comm type motor value
%    input = [ 01,  06, 209,  00,    00];
%    ToWrite = TCMLcoder(input);
%    fwrite(Motor0,ToWrite);
%    reply0 = TCMLdecoder(Motor0);
%    %        add comm type motor speed
%    input = [ 01,  00,  00,  00,    40];
%    ToWrite = TCMLcoder(input);
%    fwrite(Motor0,ToWrite);
%    reply1 = TCMLdecoder(Motor0);
%    pause(1);
% 
%    %        add comm type motor speed
%    input = [ 01,  03,  00,  00,    00];
%    ToWrite = TCMLcoder(input);
%    fwrite(Motor0,ToWrite);
%    reply3 = TCMLdecoder(Motor0);
%    %        add comm type motor value
%    input = [ 01,  06, 209,  00,    00];
%    ToWrite = TCMLcoder(input);
%    fwrite(Motor0,ToWrite);
%    reply4 = TCMLdecoder(Motor0);
%    
%    fclose(Motor0);
%    delete(Motor0);
%    clear Motor0 
%
%    Check also:
%      TCMLcoder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ToRead = TCMLdecoder(input)
% % %Test data should be >>hex2dec('FF FF FF FF') = 4294967295 
% % val1 = 255%'FF'
% % val2 = val1; val3 = val1; val4 = val1;
%
% % %Test secuence
% fwrite(RR(1),TCMLcoder([ 01,  06, 09,  00,    00]));
% input=fread(RR(1))';
%
addr = (input(1));
comm = (input(2));
type = (input(3));
moto = (input(4));

val1 = input(5);
val2 = input(6);
val3 = input(7);
val4 = input(8);

SumIn = input(9);
csum = uint8( bitand((addr+comm+type+moto+val1+val2+val3+val4),hex2dec('FF')));

if csum == SumIn
    Flag = 1;
else
    Flag = 0;
end

bin1 = (bitshift( val1,24 ));
bin2 = (bitshift( val2,16 ));
bin3 = (bitshift( val3,8 ));
bin4 =            val4;

Values=(bin1+bin2+bin3+bin4);

ToRead = [addr,comm,type,moto,Values,Flag];

