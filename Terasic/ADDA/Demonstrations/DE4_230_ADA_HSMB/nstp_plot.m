% (c) 2004 Altera Corporation. All rights reserved.  Altera products are protected under numerous U.S. and foreign patents, maskwork rights, copyrights and other intellectual property laws. 
% This reference design file, and your use thereof, is subject to and governed by the terms and conditions of the applicable Altera Reference Design License Agreement (found at www.altera.com).
% By using this reference design file, you indicate your acceptance of such terms and conditions between you and Altera Corporation. 
% In the event that you do not agree with such terms and conditions, you may not use the reference design file and please promptly destroy any copies you have made.
% This reference design file being provided on an "as-is" basis and as an accommodation and therefore all warranties, representations or guarantees of any kind (whether express, implied or statutory)
% including, without limitation, warranties of merchantability, non-infringement, or fitness for a particular purpose, are specifically disclaimed.
% By making this reference design file available, Altera expressly does not recommend, suggest or require that this reference design file be used in combination with any other product not provided by Altera

%
% The input of this program is SignalTap II data output file. 
% It extracts the DAC input samples and the ADC output samples from this file and 
% performs normalized (subtracts the DC components that are introduced due to 
% 2's complement to unsigned integer data conversion) FFT transform on the data
% and plots the results.
% Example: nstp_plot('Stp1_auto_signaltap_0.txt');
%

function [A2D, D2A]= nstp_plot(stp_txt_file_name)

%A2D_SignalName = 'HSTCD_AD_DA';
A2D_SignalName = 'HSMB_ADC_DB';
A2D_Index = 0;
D2A_SignalName = 'HSMB_DAC_DB';
D2A_Index = 0;

A2D='';
D2A='';
close all;


if ~isempty(dir(stp_txt_file_name))
    startdata=0;
    first_data=0;
    fid = fopen(stp_txt_file_name);
    if fid ~= -1    % file open is OK.
%----- get signal index---------------------------------
        key_hit = 0;
        while(key_hit == 0)
            tline = fgetl(fid); % get one line string
            disp(tline); % for debug
            if (strcmp(strtok(tline), 'Key'))
                fprintf ('hit\n');  % for debug
                key_hit = 1;
                ken_fine_end = 0;
                tline = fgetl(fid);     % read space line
                while (ken_fine_end == 0)
                    tline = fgetl(fid);
                    ken_fine_end = isempty(tline);  % if space line, setup find to end
                    [key_Index,      tline]  = strtok(tline);
                    [key_Equ,        tline]  = strtok(tline);
                    [key_signalName, tline]  = strtok(tline);
                    fprintf ('\"%s\"  \"%s\"  \"%s\" \n',key_Index,key_Equ,key_signalName);  % for debug
                    if (strcmp(key_signalName,A2D_SignalName))
                        A2D_Index = sscanf(key_Index,'%d') + 2; % add 2 to correct sample number and array index.
                        fprintf ('A2D Hit, Index = %d\n',A2D_Index);  % for debug
                    else
                        if (strcmp(key_signalName,D2A_SignalName))
                        D2A_Index = sscanf(key_Index,'%d') + 2; % add 2 to correct sample number and array index.
                            fprintf ('D2A Hit, Index = %d\n',D2A_Index);  % for debug
                        end;
                    end;
                end;
            end;
        end;

        while (feof(fid)<1)
            tline = fgetl(fid);
            if (strcmp(tline, 'sample'))
                startdata=1;
            end;
            if (startdata==1) && (length(tline)>10)
                a = sscanf(tline,'%d');
%                if (length(a) > max(A2D_Index,D2A_Index))
                    if (first_data == 0)
                        A2D = a(A2D_Index);
                        D2A = a(D2A_Index);
                    else
                        A2D = [A2D a(A2D_Index)];
                        D2A = [D2A a(D2A_Index)];
                    end;
%                end;
                first_data = first_data + 1;
            end;
        end;
        fclose(fid);
    end;
else
    disp(['  unable to locate : ' stp_txt_file_name]);
end;


if length(A2D)>2^11-1
    if (strcmp(A2D_SignalName,'HSTCD_AD_DA'))
        STII_FFTPLOT(A2D-2048*4,'ADA Development Kit - Normalized spectral plot of the 14 bit output bus of ADC_A (J1)');
    elseif (strcmp(A2D_SignalName,'HSMB_ADC_DB'))
        STII_FFTPLOT(A2D-2048*4,'ADA Development Kit - Normalized spectral plot of the 14 bit output bus of ADC_B (J2)');
    end;
end


if length(D2A)>2^11-1
    STII_FFTPLOT(D2A-2048*4,'ADA Development Kit - Normalized spectral plot of 14 bits of input data of DAC_B (J4)');
end


% ===================================================================
% function STII_FFTPLOT(data,ttitle)
% input data	data	: input data sequence
%               ttitle	: plot title string
function STII_FFTPLOT(data,ttitle)
fs = 1e5;
color ='r';
N=(2^11);

data = data(1:N);
snc=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kaiser window values
w =[0.000053;
0.000057;
0.000060;
0.000064;
0.000069;
0.000073;
0.000077;
0.000082;
0.000087;
0.000092;
0.000097;
0.000102;
0.000107;
0.000113;
0.000118;
0.000124;
0.000130;
0.000137;
0.000143;
0.000149;
0.000156;
0.000163;
0.000170;
0.000178;
0.000185;
0.000193;
0.000201;
0.000209;
0.000217;
0.000226;
0.000235;
0.000244;
0.000253;
0.000262;
0.000272;
0.000282;
0.000292;
0.000303;
0.000313;
0.000324;
0.000336;
0.000347;
0.000359;
0.000371;
0.000383;
0.000396;
0.000409;
0.000422;
0.000435;
0.000449;
0.000463;
0.000477;
0.000492;
0.000507;
0.000523;
0.000538;
0.000554;
0.000571;
0.000587;
0.000604;
0.000622;
0.000640;
0.000658;
0.000676;
0.000695;
0.000715;
0.000734;
0.000754;
0.000775;
0.000796;
0.000817;
0.000839;
0.000861;
0.000883;
0.000906;
0.000930;
0.000954;
0.000978;
0.001003;
0.001028;
0.001054;
0.001080;
0.001107;
0.001134;
0.001162;
0.001190;
0.001219;
0.001248;
0.001278;
0.001308;
0.001339;
0.001371;
0.001402;
0.001435;
0.001468;
0.001502;
0.001536;
0.001571;
0.001606;
0.001642;
0.001679;
0.001716;
0.001754;
0.001793;
0.001832;
0.001872;
0.001912;
0.001953;
0.001995;
0.002038;
0.002081;
0.002125;
0.002169;
0.002215;
0.002261;
0.002308;
0.002355;
0.002403;
0.002453;
0.002502;
0.002553;
0.002604;
0.002656;
0.002709;
0.002763;
0.002818;
0.002873;
0.002929;
0.002987;
0.003044;
0.003103;
0.003163;
0.003224;
0.003285;
0.003347;
0.003411;
0.003475;
0.003540;
0.003606;
0.003673;
0.003741;
0.003810;
0.003880;
0.003951;
0.004023;
0.004096;
0.004170;
0.004245;
0.004321;
0.004398;
0.004477;
0.004556;
0.004636;
0.004718;
0.004800;
0.004884;
0.004969;
0.005055;
0.005142;
0.005230;
0.005320;
0.005410;
0.005502;
0.005595;
0.005689;
0.005785;
0.005882;
0.005980;
0.006079;
0.006179;
0.006281;
0.006384;
0.006489;
0.006595;
0.006702;
0.006810;
0.006920;
0.007031;
0.007144;
0.007258;
0.007373;
0.007490;
0.007608;
0.007728;
0.007849;
0.007972;
0.008096;
0.008222;
0.008349;
0.008478;
0.008608;
0.008740;
0.008873;
0.009008;
0.009145;
0.009283;
0.009423;
0.009564;
0.009707;
0.009852;
0.009998;
0.010146;
0.010296;
0.010447;
0.010601;
0.010756;
0.010912;
0.011071;
0.011231;
0.011393;
0.011557;
0.011723;
0.011890;
0.012060;
0.012231;
0.012404;
0.012579;
0.012756;
0.012935;
0.013116;
0.013299;
0.013483;
0.013670;
0.013859;
0.014050;
0.014243;
0.014437;
0.014634;
0.014833;
0.015034;
0.015238;
0.015443;
0.015650;
0.015860;
0.016072;
0.016286;
0.016502;
0.016720;
0.016941;
0.017164;
0.017389;
0.017616;
0.017846;
0.018078;
0.018312;
0.018549;
0.018788;
0.019030;
0.019273;
0.019519;
0.019768;
0.020019;
0.020273;
0.020529;
0.020787;
0.021048;
0.021311;
0.021577;
0.021846;
0.022117;
0.022391;
0.022667;
0.022946;
0.023228;
0.023512;
0.023799;
0.024088;
0.024380;
0.024675;
0.024973;
0.025273;
0.025576;
0.025882;
0.026191;
0.026503;
0.026817;
0.027134;
0.027454;
0.027777;
0.028103;
0.028432;
0.028764;
0.029098;
0.029436;
0.029777;
0.030120;
0.030467;
0.030817;
0.031169;
0.031525;
0.031884;
0.032246;
0.032611;
0.032979;
0.033350;
0.033725;
0.034103;
0.034484;
0.034868;
0.035255;
0.035646;
0.036039;
0.036437;
0.036837;
0.037241;
0.037648;
0.038058;
0.038472;
0.038889;
0.039310;
0.039734;
0.040162;
0.040593;
0.041027;
0.041465;
0.041906;
0.042351;
0.042800;
0.043252;
0.043707;
0.044167;
0.044629;
0.045096;
0.045566;
0.046040;
0.046517;
0.046998;
0.047483;
0.047972;
0.048464;
0.048960;
0.049460;
0.049963;
0.050471;
0.050982;
0.051497;
0.052016;
0.052539;
0.053066;
0.053596;
0.054131;
0.054669;
0.055212;
0.055758;
0.056309;
0.056863;
0.057421;
0.057984;
0.058550;
0.059121;
0.059696;
0.060274;
0.060857;
0.061444;
0.062036;
0.062631;
0.063230;
0.063834;
0.064442;
0.065054;
0.065671;
0.066291;
0.066916;
0.067546;
0.068179;
0.068817;
0.069459;
0.070106;
0.070757;
0.071412;
0.072072;
0.072736;
0.073404;
0.074077;
0.074755;
0.075437;
0.076123;
0.076814;
0.077510;
0.078210;
0.078914;
0.079623;
0.080337;
0.081055;
0.081778;
0.082505;
0.083237;
0.083974;
0.084715;
0.085461;
0.086212;
0.086967;
0.087727;
0.088492;
0.089262;
0.090036;
0.090815;
0.091599;
0.092387;
0.093181;
0.093979;
0.094782;
0.095590;
0.096403;
0.097220;
0.098043;
0.098870;
0.099702;
0.100539;
0.101381;
0.102228;
0.103080;
0.103937;
0.104799;
0.105666;
0.106538;
0.107415;
0.108297;
0.109183;
0.110075;
0.110972;
0.111874;
0.112781;
0.113693;
0.114610;
0.115533;
0.116460;
0.117393;
0.118330;
0.119273;
0.120221;
0.121174;
0.122132;
0.123095;
0.124064;
0.125038;
0.126017;
0.127001;
0.127990;
0.128985;
0.129984;
0.130989;
0.132000;
0.133015;
0.134036;
0.135062;
0.136093;
0.137129;
0.138171;
0.139218;
0.140271;
0.141328;
0.142391;
0.143460;
0.144533;
0.145612;
0.146697;
0.147786;
0.148881;
0.149982;
0.151087;
0.152198;
0.153315;
0.154436;
0.155563;
0.156696;
0.157834;
0.158977;
0.160126;
0.161280;
0.162439;
0.163604;
0.164774;
0.165950;
0.167131;
0.168317;
0.169509;
0.170706;
0.171909;
0.173117;
0.174330;
0.175549;
0.176774;
0.178003;
0.179238;
0.180479;
0.181725;
0.182976;
0.184233;
0.185495;
0.186763;
0.188036;
0.189315;
0.190598;
0.191888;
0.193183;
0.194483;
0.195788;
0.197099;
0.198416;
0.199737;
0.201065;
0.202397;
0.203735;
0.205079;
0.206428;
0.207782;
0.209141;
0.210506;
0.211877;
0.213252;
0.214633;
0.216020;
0.217412;
0.218809;
0.220211;
0.221619;
0.223032;
0.224451;
0.225875;
0.227304;
0.228739;
0.230178;
0.231623;
0.233074;
0.234530;
0.235991;
0.237457;
0.238928;
0.240405;
0.241887;
0.243374;
0.244867;
0.246365;
0.247868;
0.249376;
0.250889;
0.252408;
0.253931;
0.255460;
0.256994;
0.258533;
0.260078;
0.261627;
0.263182;
0.264741;
0.266306;
0.267876;
0.269451;
0.271031;
0.272616;
0.274206;
0.275801;
0.277401;
0.279006;
0.280616;
0.282230;
0.283850;
0.285475;
0.287105;
0.288739;
0.290379;
0.292023;
0.293672;
0.295327;
0.296985;
0.298649;
0.300318;
0.301991;
0.303669;
0.305352;
0.307039;
0.308731;
0.310428;
0.312130;
0.313836;
0.315547;
0.317262;
0.318982;
0.320707;
0.322436;
0.324169;
0.325908;
0.327650;
0.329398;
0.331149;
0.332905;
0.334666;
0.336431;
0.338200;
0.339973;
0.341751;
0.343534;
0.345320;
0.347111;
0.348906;
0.350705;
0.352509;
0.354316;
0.356128;
0.357944;
0.359764;
0.361588;
0.363416;
0.365248;
0.367084;
0.368924;
0.370768;
0.372616;
0.374468;
0.376324;
0.378184;
0.380047;
0.381914;
0.383785;
0.385660;
0.387538;
0.389420;
0.391306;
0.393195;
0.395088;
0.396985;
0.398885;
0.400789;
0.402696;
0.404606;
0.406520;
0.408438;
0.410358;
0.412282;
0.414210;
0.416140;
0.418074;
0.420011;
0.421952;
0.423895;
0.425842;
0.427791;
0.429744;
0.431699;
0.433658;
0.435620;
0.437584;
0.439552;
0.441522;
0.443495;
0.445471;
0.447450;
0.449431;
0.451415;
0.453402;
0.455391;
0.457383;
0.459378;
0.461375;
0.463374;
0.465376;
0.467380;
0.469387;
0.471396;
0.473407;
0.475421;
0.477437;
0.479455;
0.481475;
0.483497;
0.485521;
0.487548;
0.489576;
0.491606;
0.493638;
0.495672;
0.497708;
0.499746;
0.501786;
0.503827;
0.505870;
0.507914;
0.509960;
0.512008;
0.514057;
0.516108;
0.518160;
0.520214;
0.522269;
0.524325;
0.526383;
0.528442;
0.530502;
0.532563;
0.534625;
0.536688;
0.538753;
0.540818;
0.542884;
0.544952;
0.547020;
0.549089;
0.551158;
0.553229;
0.555300;
0.557372;
0.559444;
0.561517;
0.563590;
0.565664;
0.567739;
0.569813;
0.571888;
0.573964;
0.576039;
0.578115;
0.580191;
0.582267;
0.584344;
0.586420;
0.588496;
0.590572;
0.592648;
0.594724;
0.596800;
0.598875;
0.600950;
0.603025;
0.605099;
0.607173;
0.609247;
0.611320;
0.613392;
0.615464;
0.617535;
0.619605;
0.621675;
0.623743;
0.625811;
0.627878;
0.629945;
0.632010;
0.634074;
0.636137;
0.638198;
0.640259;
0.642318;
0.644377;
0.646433;
0.648489;
0.650543;
0.652595;
0.654646;
0.656695;
0.658743;
0.660789;
0.662834;
0.664876;
0.666917;
0.668956;
0.670993;
0.673028;
0.675061;
0.677092;
0.679121;
0.681147;
0.683172;
0.685194;
0.687214;
0.689232;
0.691247;
0.693259;
0.695270;
0.697277;
0.699282;
0.701284;
0.703284;
0.705281;
0.707275;
0.709266;
0.711255;
0.713240;
0.715222;
0.717202;
0.719178;
0.721151;
0.723121;
0.725088;
0.727051;
0.729011;
0.730967;
0.732921;
0.734870;
0.736816;
0.738759;
0.740698;
0.742633;
0.744564;
0.746492;
0.748415;
0.750335;
0.752251;
0.754163;
0.756071;
0.757975;
0.759874;
0.761770;
0.763661;
0.765548;
0.767430;
0.769308;
0.771182;
0.773051;
0.774916;
0.776776;
0.778632;
0.780483;
0.782329;
0.784170;
0.786006;
0.787838;
0.789664;
0.791486;
0.793303;
0.795114;
0.796921;
0.798722;
0.800518;
0.802309;
0.804094;
0.805874;
0.807649;
0.809418;
0.811182;
0.812940;
0.814693;
0.816440;
0.818181;
0.819916;
0.821646;
0.823370;
0.825088;
0.826800;
0.828506;
0.830206;
0.831900;
0.833588;
0.835269;
0.836945;
0.838614;
0.840277;
0.841933;
0.843584;
0.845227;
0.846865;
0.848495;
0.850119;
0.851737;
0.853348;
0.854952;
0.856549;
0.858140;
0.859724;
0.861300;
0.862870;
0.864433;
0.865989;
0.867538;
0.869080;
0.870614;
0.872142;
0.873662;
0.875175;
0.876680;
0.878178;
0.879669;
0.881153;
0.882628;
0.884097;
0.885557;
0.887011;
0.888456;
0.889894;
0.891324;
0.892746;
0.894161;
0.895567;
0.896966;
0.898357;
0.899739;
0.901114;
0.902481;
0.903839;
0.905190;
0.906532;
0.907866;
0.909192;
0.910509;
0.911819;
0.913119;
0.914412;
0.915696;
0.916971;
0.918238;
0.919497;
0.920747;
0.921988;
0.923220;
0.924444;
0.925659;
0.926866;
0.928063;
0.929252;
0.930432;
0.931603;
0.932765;
0.933918;
0.935062;
0.936197;
0.937323;
0.938440;
0.939547;
0.940646;
0.941735;
0.942815;
0.943886;
0.944947;
0.946000;
0.947042;
0.948076;
0.949100;
0.950114;
0.951120;
0.952115;
0.953101;
0.954078;
0.955044;
0.956002;
0.956949;
0.957887;
0.958815;
0.959734;
0.960642;
0.961541;
0.962430;
0.963310;
0.964179;
0.965039;
0.965888;
0.966728;
0.967557;
0.968377;
0.969187;
0.969986;
0.970776;
0.971555;
0.972324;
0.973083;
0.973832;
0.974571;
0.975300;
0.976018;
0.976726;
0.977424;
0.978112;
0.978789;
0.979456;
0.980113;
0.980759;
0.981395;
0.982020;
0.982635;
0.983240;
0.983834;
0.984417;
0.984990;
0.985553;
0.986105;
0.986646;
0.987177;
0.987698;
0.988207;
0.988707;
0.989195;
0.989673;
0.990140;
0.990597;
0.991043;
0.991478;
0.991902;
0.992316;
0.992719;
0.993111;
0.993493;
0.993863;
0.994223;
0.994573;
0.994911;
0.995238;
0.995555;
0.995861;
0.996156;
0.996440;
0.996713;
0.996976;
0.997227;
0.997468;
0.997698;
0.997917;
0.998125;
0.998322;
0.998508;
0.998683;
0.998848;
0.999001;
0.999144;
0.999275;
0.999396;
0.999505;
0.999604;
0.999692;
0.999768;
0.999834;
0.999889;
0.999933;
0.999966;
0.999988;
0.999999;
0.999999;
0.999988;
0.999966;
0.999933;
0.999889;
0.999834;
0.999768;
0.999692;
0.999604;
0.999505;
0.999396;
0.999275;
0.999144;
0.999001;
0.998848;
0.998683;
0.998508;
0.998322;
0.998125;
0.997917;
0.997698;
0.997468;
0.997227;
0.996976;
0.996713;
0.996440;
0.996156;
0.995861;
0.995555;
0.995238;
0.994911;
0.994573;
0.994223;
0.993863;
0.993493;
0.993111;
0.992719;
0.992316;
0.991902;
0.991478;
0.991043;
0.990597;
0.990140;
0.989673;
0.989195;
0.988707;
0.988207;
0.987698;
0.987177;
0.986646;
0.986105;
0.985553;
0.984990;
0.984417;
0.983834;
0.983240;
0.982635;
0.982020;
0.981395;
0.980759;
0.980113;
0.979456;
0.978789;
0.978112;
0.977424;
0.976726;
0.976018;
0.975300;
0.974571;
0.973832;
0.973083;
0.972324;
0.971555;
0.970776;
0.969986;
0.969187;
0.968377;
0.967557;
0.966728;
0.965888;
0.965039;
0.964179;
0.963310;
0.962430;
0.961541;
0.960642;
0.959734;
0.958815;
0.957887;
0.956949;
0.956002;
0.955044;
0.954078;
0.953101;
0.952115;
0.951120;
0.950114;
0.949100;
0.948076;
0.947042;
0.946000;
0.944947;
0.943886;
0.942815;
0.941735;
0.940646;
0.939547;
0.938440;
0.937323;
0.936197;
0.935062;
0.933918;
0.932765;
0.931603;
0.930432;
0.929252;
0.928063;
0.926866;
0.925659;
0.924444;
0.923220;
0.921988;
0.920747;
0.919497;
0.918238;
0.916971;
0.915696;
0.914412;
0.913119;
0.911819;
0.910509;
0.909192;
0.907866;
0.906532;
0.905190;
0.903839;
0.902481;
0.901114;
0.899739;
0.898357;
0.896966;
0.895567;
0.894161;
0.892746;
0.891324;
0.889894;
0.888456;
0.887011;
0.885557;
0.884097;
0.882628;
0.881153;
0.879669;
0.878178;
0.876680;
0.875175;
0.873662;
0.872142;
0.870614;
0.869080;
0.867538;
0.865989;
0.864433;
0.862870;
0.861300;
0.859724;
0.858140;
0.856549;
0.854952;
0.853348;
0.851737;
0.850119;
0.848495;
0.846865;
0.845227;
0.843584;
0.841933;
0.840277;
0.838614;
0.836945;
0.835269;
0.833588;
0.831900;
0.830206;
0.828506;
0.826800;
0.825088;
0.823370;
0.821646;
0.819916;
0.818181;
0.816440;
0.814693;
0.812940;
0.811182;
0.809418;
0.807649;
0.805874;
0.804094;
0.802309;
0.800518;
0.798722;
0.796921;
0.795114;
0.793303;
0.791486;
0.789664;
0.787838;
0.786006;
0.784170;
0.782329;
0.780483;
0.778632;
0.776776;
0.774916;
0.773051;
0.771182;
0.769308;
0.767430;
0.765548;
0.763661;
0.761770;
0.759874;
0.757975;
0.756071;
0.754163;
0.752251;
0.750335;
0.748415;
0.746492;
0.744564;
0.742633;
0.740698;
0.738759;
0.736816;
0.734870;
0.732921;
0.730967;
0.729011;
0.727051;
0.725088;
0.723121;
0.721151;
0.719178;
0.717202;
0.715222;
0.713240;
0.711255;
0.709266;
0.707275;
0.705281;
0.703284;
0.701284;
0.699282;
0.697277;
0.695270;
0.693259;
0.691247;
0.689232;
0.687214;
0.685194;
0.683172;
0.681147;
0.679121;
0.677092;
0.675061;
0.673028;
0.670993;
0.668956;
0.666917;
0.664876;
0.662834;
0.660789;
0.658743;
0.656695;
0.654646;
0.652595;
0.650543;
0.648489;
0.646433;
0.644377;
0.642318;
0.640259;
0.638198;
0.636137;
0.634074;
0.632010;
0.629945;
0.627878;
0.625811;
0.623743;
0.621675;
0.619605;
0.617535;
0.615464;
0.613392;
0.611320;
0.609247;
0.607173;
0.605099;
0.603025;
0.600950;
0.598875;
0.596800;
0.594724;
0.592648;
0.590572;
0.588496;
0.586420;
0.584344;
0.582267;
0.580191;
0.578115;
0.576039;
0.573964;
0.571888;
0.569813;
0.567739;
0.565664;
0.563590;
0.561517;
0.559444;
0.557372;
0.555300;
0.553229;
0.551158;
0.549089;
0.547020;
0.544952;
0.542884;
0.540818;
0.538753;
0.536688;
0.534625;
0.532563;
0.530502;
0.528442;
0.526383;
0.524325;
0.522269;
0.520214;
0.518160;
0.516108;
0.514057;
0.512008;
0.509960;
0.507914;
0.505870;
0.503827;
0.501786;
0.499746;
0.497708;
0.495672;
0.493638;
0.491606;
0.489576;
0.487548;
0.485521;
0.483497;
0.481475;
0.479455;
0.477437;
0.475421;
0.473407;
0.471396;
0.469387;
0.467380;
0.465376;
0.463374;
0.461375;
0.459378;
0.457383;
0.455391;
0.453402;
0.451415;
0.449431;
0.447450;
0.445471;
0.443495;
0.441522;
0.439552;
0.437584;
0.435620;
0.433658;
0.431699;
0.429744;
0.427791;
0.425842;
0.423895;
0.421952;
0.420011;
0.418074;
0.416140;
0.414210;
0.412282;
0.410358;
0.408438;
0.406520;
0.404606;
0.402696;
0.400789;
0.398885;
0.396985;
0.395088;
0.393195;
0.391306;
0.389420;
0.387538;
0.385660;
0.383785;
0.381914;
0.380047;
0.378184;
0.376324;
0.374468;
0.372616;
0.370768;
0.368924;
0.367084;
0.365248;
0.363416;
0.361588;
0.359764;
0.357944;
0.356128;
0.354316;
0.352509;
0.350705;
0.348906;
0.347111;
0.345320;
0.343534;
0.341751;
0.339973;
0.338200;
0.336431;
0.334666;
0.332905;
0.331149;
0.329398;
0.327650;
0.325908;
0.324169;
0.322436;
0.320707;
0.318982;
0.317262;
0.315547;
0.313836;
0.312130;
0.310428;
0.308731;
0.307039;
0.305352;
0.303669;
0.301991;
0.300318;
0.298649;
0.296985;
0.295327;
0.293672;
0.292023;
0.290379;
0.288739;
0.287105;
0.285475;
0.283850;
0.282230;
0.280616;
0.279006;
0.277401;
0.275801;
0.274206;
0.272616;
0.271031;
0.269451;
0.267876;
0.266306;
0.264741;
0.263182;
0.261627;
0.260078;
0.258533;
0.256994;
0.255460;
0.253931;
0.252408;
0.250889;
0.249376;
0.247868;
0.246365;
0.244867;
0.243374;
0.241887;
0.240405;
0.238928;
0.237457;
0.235991;
0.234530;
0.233074;
0.231623;
0.230178;
0.228739;
0.227304;
0.225875;
0.224451;
0.223032;
0.221619;
0.220211;
0.218809;
0.217412;
0.216020;
0.214633;
0.213252;
0.211877;
0.210506;
0.209141;
0.207782;
0.206428;
0.205079;
0.203735;
0.202397;
0.201065;
0.199737;
0.198416;
0.197099;
0.195788;
0.194483;
0.193183;
0.191888;
0.190598;
0.189315;
0.188036;
0.186763;
0.185495;
0.184233;
0.182976;
0.181725;
0.180479;
0.179238;
0.178003;
0.176774;
0.175549;
0.174330;
0.173117;
0.171909;
0.170706;
0.169509;
0.168317;
0.167131;
0.165950;
0.164774;
0.163604;
0.162439;
0.161280;
0.160126;
0.158977;
0.157834;
0.156696;
0.155563;
0.154436;
0.153315;
0.152198;
0.151087;
0.149982;
0.148881;
0.147786;
0.146697;
0.145612;
0.144533;
0.143460;
0.142391;
0.141328;
0.140271;
0.139218;
0.138171;
0.137129;
0.136093;
0.135062;
0.134036;
0.133015;
0.132000;
0.130989;
0.129984;
0.128985;
0.127990;
0.127001;
0.126017;
0.125038;
0.124064;
0.123095;
0.122132;
0.121174;
0.120221;
0.119273;
0.118330;
0.117393;
0.116460;
0.115533;
0.114610;
0.113693;
0.112781;
0.111874;
0.110972;
0.110075;
0.109183;
0.108297;
0.107415;
0.106538;
0.105666;
0.104799;
0.103937;
0.103080;
0.102228;
0.101381;
0.100539;
0.099702;
0.098870;
0.098043;
0.097220;
0.096403;
0.095590;
0.094782;
0.093979;
0.093181;
0.092387;
0.091599;
0.090815;
0.090036;
0.089262;
0.088492;
0.087727;
0.086967;
0.086212;
0.085461;
0.084715;
0.083974;
0.083237;
0.082505;
0.081778;
0.081055;
0.080337;
0.079623;
0.078914;
0.078210;
0.077510;
0.076814;
0.076123;
0.075437;
0.074755;
0.074077;
0.073404;
0.072736;
0.072072;
0.071412;
0.070757;
0.070106;
0.069459;
0.068817;
0.068179;
0.067546;
0.066916;
0.066291;
0.065671;
0.065054;
0.064442;
0.063834;
0.063230;
0.062631;
0.062036;
0.061444;
0.060857;
0.060274;
0.059696;
0.059121;
0.058550;
0.057984;
0.057421;
0.056863;
0.056309;
0.055758;
0.055212;
0.054669;
0.054131;
0.053596;
0.053066;
0.052539;
0.052016;
0.051497;
0.050982;
0.050471;
0.049963;
0.049460;
0.048960;
0.048464;
0.047972;
0.047483;
0.046998;
0.046517;
0.046040;
0.045566;
0.045096;
0.044629;
0.044167;
0.043707;
0.043252;
0.042800;
0.042351;
0.041906;
0.041465;
0.041027;
0.040593;
0.040162;
0.039734;
0.039310;
0.038889;
0.038472;
0.038058;
0.037648;
0.037241;
0.036837;
0.036437;
0.036039;
0.035646;
0.035255;
0.034868;
0.034484;
0.034103;
0.033725;
0.033350;
0.032979;
0.032611;
0.032246;
0.031884;
0.031525;
0.031169;
0.030817;
0.030467;
0.030120;
0.029777;
0.029436;
0.029098;
0.028764;
0.028432;
0.028103;
0.027777;
0.027454;
0.027134;
0.026817;
0.026503;
0.026191;
0.025882;
0.025576;
0.025273;
0.024973;
0.024675;
0.024380;
0.024088;
0.023799;
0.023512;
0.023228;
0.022946;
0.022667;
0.022391;
0.022117;
0.021846;
0.021577;
0.021311;
0.021048;
0.020787;
0.020529;
0.020273;
0.020019;
0.019768;
0.019519;
0.019273;
0.019030;
0.018788;
0.018549;
0.018312;
0.018078;
0.017846;
0.017616;
0.017389;
0.017164;
0.016941;
0.016720;
0.016502;
0.016286;
0.016072;
0.015860;
0.015650;
0.015443;
0.015238;
0.015034;
0.014833;
0.014634;
0.014437;
0.014243;
0.014050;
0.013859;
0.013670;
0.013483;
0.013299;
0.013116;
0.012935;
0.012756;
0.012579;
0.012404;
0.012231;
0.012060;
0.011890;
0.011723;
0.011557;
0.011393;
0.011231;
0.011071;
0.010912;
0.010756;
0.010601;
0.010447;
0.010296;
0.010146;
0.009998;
0.009852;
0.009707;
0.009564;
0.009423;
0.009283;
0.009145;
0.009008;
0.008873;
0.008740;
0.008608;
0.008478;
0.008349;
0.008222;
0.008096;
0.007972;
0.007849;
0.007728;
0.007608;
0.007490;
0.007373;
0.007258;
0.007144;
0.007031;
0.006920;
0.006810;
0.006702;
0.006595;
0.006489;
0.006384;
0.006281;
0.006179;
0.006079;
0.005980;
0.005882;
0.005785;
0.005689;
0.005595;
0.005502;
0.005410;
0.005320;
0.005230;
0.005142;
0.005055;
0.004969;
0.004884;
0.004800;
0.004718;
0.004636;
0.004556;
0.004477;
0.004398;
0.004321;
0.004245;
0.004170;
0.004096;
0.004023;
0.003951;
0.003880;
0.003810;
0.003741;
0.003673;
0.003606;
0.003540;
0.003475;
0.003411;
0.003347;
0.003285;
0.003224;
0.003163;
0.003103;
0.003044;
0.002987;
0.002929;
0.002873;
0.002818;
0.002763;
0.002709;
0.002656;
0.002604;
0.002553;
0.002502;
0.002453;
0.002403;
0.002355;
0.002308;
0.002261;
0.002215;
0.002169;
0.002125;
0.002081;
0.002038;
0.001995;
0.001953;
0.001912;
0.001872;
0.001832;
0.001793;
0.001754;
0.001716;
0.001679;
0.001642;
0.001606;
0.001571;
0.001536;
0.001502;
0.001468;
0.001435;
0.001402;
0.001371;
0.001339;
0.001308;
0.001278;
0.001248;
0.001219;
0.001190;
0.001162;
0.001134;
0.001107;
0.001080;
0.001054;
0.001028;
0.001003;
0.000978;
0.000954;
0.000930;
0.000906;
0.000883;
0.000861;
0.000839;
0.000817;
0.000796;
0.000775;
0.000754;
0.000734;
0.000715;
0.000695;
0.000676;
0.000658;
0.000640;
0.000622;
0.000604;
0.000587;
0.000571;
0.000554;
0.000538;
0.000523;
0.000507;
0.000492;
0.000477;
0.000463;
0.000449;
0.000435;
0.000422;
0.000409;
0.000396;
0.000383;
0.000371;
0.000359;
0.000347;
0.000336;
0.000324;
0.000313;
0.000303;
0.000292;
0.000282;
0.000272;
0.000262;
0.000253;
0.000244;
0.000235;
0.000226;
0.000217;
0.000209;
0.000201;
0.000193;
0.000185;
0.000178;
0.000170;
0.000163;
0.000156;
0.000149;
0.000143;
0.000137;
0.000130;
0.000124;
0.000118;
0.000113;
0.000107;
0.000102;
0.000097;
0.000092;
0.000087;
0.000082;
0.000077;
0.000073;
0.000069;
0.000064;
0.000060;
0.000057;
0.000053];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = data.*w';

S=abs(fft(data));
S = S./max(S);
S = 20*log10(S+1e-15);

xvals = linspace(0,floor(fs/2)-floor((fs/N)),N/2);

figure;    
plot(xvals(1:N/2),S(1:N/2),color), grid on,axis([0,floor(fs/2)-1,-150,20]);
%plot(xvals(1:N/2),S(1:N/2),color), grid on,axis([0,50000-1,-150,20]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title(ttitle);
