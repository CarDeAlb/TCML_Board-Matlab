%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               TU Braunschweig - Raumfahrtsysteme Institut               %
%               http://www.space-systems.eu/index.php/de/                 %
%                    Copyright IRAS - TUBS 2017-2018                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%            ToWrite = TCMLcoder(Input)
%
%  Input: 5-element vector
%         
%         Input = [ addr, comm, type, moto, values]; 
%      addr: address of the comm-port (could be consulted using TMCL - IDE)
%      comm: Command number listed on TMCL^TM Firmware Manual 
%            (Should be introduced the numeric form)
%      type: Type number listed on TMCL^TM Firmware Manual 
%            (Should be introduced the numeric form)
%      motor: Motor or Bank number listed on TMCL^TM Firmware Manual 
%            (Should be introduced the numeric form)
%      values: Value number listed on TMCL^TM Firmware Manual 
%            (Should be introduced the numeric form)
%            
%           Further information could be consulted on:
%           TMCL^TM Firmware Manual TMCM-351 
%           available on http://www.trinamic.com
%    
%  Output:
%    ToWrite: 9-bit binary-word, 
%                     1-byte Module address 
%                     1-byte Command Number
%                     1-byte Type number
%                     4-byte Motor or Bank number
%                     1-byte Value number
%                     1-byte Checksum
%
%   Description: 
%    This function allows to encode the commands devices of 
%       Trinamic Motion Control GmbH & Co. KG   http://www.trinamic.com
%    Following "Binary command format" suggested for serial communication
%    (USB, RS232, RS485). This script also calculates checksum and attaches
%     it to the binary-word to be send.
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
%    %        add comm type motor values
%    input = [ 01,  00,  00,  00,    40];
%    ToWrite = TCMLcoder(input);
%    fwrite(Motor0,ToWrite);
%    reply0 = fread(Motor0)';
%    pause(1);
% 
%    %      add comm type motor values
%    input = [ 01,  03,  00,  00,    00];
%    ToWrite = TCMLcoder(input);
%    fwrite(Motor0,ToWrite);
%    reply1 = TCMLdecoder(Motor0);
%    
%    fclose(Motor0);
%    delete(Motor0);
%    clear Motor0 
%
%    Check also:
%      TCMLdecoder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

function ToWrite = TCMLcoder(input)
% input=[ 01,  06, 209,  00,    00];%Test input

addr = (input(1));
comm = (input(2));
type = (input(3));
moto = (input(4));

values = abs(fix(input(5)));
val1 = (bitshift( bitand(values,hex2dec('FF000000')),-24 ));
val2 = (bitshift( bitand(values,hex2dec('00FF0000')),-16 ));
val3 = (bitshift( bitand(values,hex2dec('0000FF00')),-8 ));
val4 =           (bitand(values,hex2dec('000000FF')));

% uint8( bitand((addr+comm+type+moto+val1+val2+val3+val4),hex2dec('FF')));
csum = dec2hex(uint8(bitand((addr+comm+type+moto+val1+val2+val3+val4),hex2dec('FF'))));

ToWrite = uint8([addr,comm,type,moto,val1,val2,val3,val4,hex2dec(csum)]);